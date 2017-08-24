#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license

require_relative "Statement.rb"

class Parser
  #
  # This parser is built according to the language grammar
  #
  
  # it declares four stacks for the operation priority
  def create_stacks
    @op   = []
    @val  = []
    @bool = []
    @comp = []
  end

  # Main function that parses the entire code
  #
  # * **argument**: array of tokens
  # * **returns**:  program statement (hash)
  def parse(stream)
    @stream = stream
    @return = false
    @i = 0
    create_stacks
    ast = []
    while @i < @stream.size
      res = self.send(self.state(current_tk))
      ast.push res if res.is_a? Hash and !(res == :EOF) 
    end 
    return Statement.prog(ast)
  end
  
 protected
  
  # Function called to determine which state (function) must be called
  # according to the current token
  #
  # * **argument**: current token (object) to determine the state
  # * **argument**: boolean (optional) to understand if a void can be created
  # * **returns**:  symbol of the function to call
  def state(tk,void = true)
    case tk.tag
      when :EOL,:EOF
        return :forward
      when :KEYWORD
        case current_tk.value
          when "if"
            return :if_state
          when "void"
            if void
              return :void
            else
              current_tk.unexpected
            end
          when "print","printl"
            return :print_
          when "true","false"
            return :simple_exp
          when "do"
            return :loop
          when "return"
            if @return then
              return :return_
            else
              current_tk.unexpected
            end
          else
            current_tk.unexpected
        end
      when :VARIABLE
        return :expression
      when :NUMBER,:SUM_OP
        return :simple_exp
      when :QUOTES
        return :simple_exp
      when :L_PAR
        return :simple_exp
      else
        current_tk.unknown if current_tk.tag == :UNKNOWN
        current_tk.unexpected unless current_tk.tag == :EOF
    end
  end

  # Parses the if structure
  #
  # * **returns**: if_statement (hash)
  def if_state
    skip_token("if")
    condition = simple_exp(:KEYWORD,"then")
    skip_token("then")
    then_ = self.send(:block)
    skip_token(:EOL) if current_tk.tag == :EOL
    if current_tk .value == "else"
      skip_token "else"
      else_ = self.send(:block)
    else
      return Statement.if_statement(condition,then_)
    end
    return Statement.if_statement(condition,then_,else_)
  end
  
  # Parses the instructions of a block, eg: then-else, void-end
  #
  # * **argument**: boolean; it gives information if we are barsing an until block
  # * **returns**:  block statement (hash)
  def block(m_end = false)
    bk = []
    forward if current_tk.tag == :EOL
    if m_end then
      until current_tk.value == "until" and !end_of_stream
        res = self.send(self.state(current_tk,false))
        bk << res if res.is_a? Hash
      end
      return Statement.block(bk)
    end
    if current_tk.tag == :L_BRACE
      skip_token(:L_BRACE)
      until current_tk.tag == :R_BRACE and !end_of_stream
        res = self.send(self.state(current_tk,false))
        bk << res if res.is_a? Hash
      end
      skip_token(:R_BRACE)
    else
      until (current_tk.value == "end" or current_tk.value == "else") and (!end_of_stream)
        res = self.send(self.state(current_tk,false))
        bk << res if res.is_a? Hash
        previous_tk.meets_eof("block") if end_of_stream
      end
      skip_token("end") if current_tk.value == "end"
    end
    return Statement.block(bk)
  end
  
  # It parses a math expression assuming that it could be an assignment
  #
  # * **returns**: number statement (hash) if it finds only a number
  # * **returns**: variable statement (hash) if it finds only a variable
  # * **returns**: assign statement (hash) if it finds tokens like =, <op>=
  # <op>: +,-,*,/,^
  # * ** returns**: bin_op statement if it finds a simple expression
  # simple expression:
  # val: number/variable; op: binary/operator; bin_op: val op val
  # expression: bin_op op bin_op
  # * **returns**: comparison statement (hash) if it finds a comparison (>,<,==...)
  # * **returns**: boolean_op if it finds a boolean operation (&&,||,!)
  def expression
    case next_tk.tag
      when :EOL
        if current_tk.tag == :NUMBER then
          return Statement.number(current_tk)
        elsif current_tk.tag == :VARIABLE then
          return Statement.variable(current_tk)
        end
      when :ASSIGN
        left = current_tk
        forward
        skip_token("=")
        return Statement.assign(left,simple_exp)
      when :INCRISE_OP, :MULTIPLY, :TO_POWER
        left = current_tk
        forward
        op = current_tk.value[0]
        skip_token(current_tk.tag)
        right = Statement.bin_op(op,left,simple_exp)
        return Statement.assign(left,right)
      else
        return simple_exp
    end
  end
  
  # state 0/1 of the simple_exp parser; it accepts only numbers, variables
  # (, quotes (in case of a string) and true, false keywords
  # +,- operators (only if state is 0)
  #
  # * **argument**: Fixnum (used values; 0,1) to determine which of the
  # two states are running. 1 is default
  # * **returns**: symbol of the next state
  def state0_1(st = 1)
    case current_tk.tag
      when :L_PAR
        skip_token(:L_PAR)
        @val.push simple_exp(:R_PAR)
        return :state2
      when :SUM_OP
        if st == 0
          @op.push current_tk
          return :state0_1
        else
          current_tk.unexpected
        end
      when :VARIABLE
        if next_tk.tag == :L_PAR then
          name = current_tk
          forward
          @val.push Statement.called(name,surrounded("(",")",true))
        else
          @val.push Statement.variable(current_tk)
        end
        return :state2
      when :NUMBER
        @val.push Statement.number(current_tk)
        return :state2
      when :QUOTES
        @val.push string
        return :state2
      when :KEYWORD
        current_tk.unexpected unless ["true","false"].include?current_tk.value
        @val.push boolean
        return :state2
      when :BOOLEAN_OP
        if current_tk.value == "!" then
          @bool.push current_tk
          return :state0_1
        else
          current_tk.unexpected
        end
      else
        if st == 0
          current_tk.unexpected
        else
          previous_tk.meets_eol if current_tk.tag == :EOL
          current_tk.unexpected unless current_tk.tag == :EOL
        end
    end
  end
  
  # it builds the binary operation trees according to the values in @val
  # and the operators in @op
  # 
  def make_op
    while @op.size > 0
      op = @op.pop
      right = @val.pop
      left = @val.pop
      @val.push Statement.bin_op(op,left,right)
    end
  end
  
  # it builds the comparison tree accordng to the values in @val
  # and the comparison operator in @comp
  #
  def make_comp
    make_op
    while @comp.size > 0
      comp = @comp.pop
      right = @val.pop
      left  = @val.pop
      @val.push Statement.comparison(comp,left,right)
    end
  end
  
  # it builds the boolean_op tree according to the values in @val 
  # and the boolean operators in @bool
  #
  def make_boole
    make_comp
    while @bool.size > 0
      bool = @bool.pop
      if bool.value == "!" then
        right = @val.pop
        @val.push Statement.logical_not(right)
      else
        right = @val.pop
        left = @val.pop
        @val.push Statement.logical_op(bool,left,right) 
      end
    end
  end
  
  # stete 2 of the simple_exp parser; it accepts only operators,
  # comparison operators, boolean operators
  #
  # * **returns**: symbol of the next state
  def state2
    case current_tk.tag
      when :SUM_OP,:MUL_OP,:POWER
        if @op.size == 0 then
          @op.push current_tk
        elsif priority(current_tk.value) > priority(@op.last.value) then
          @op.push current_tk
        elsif priority(current_tk.value) == priority(@op.last.value) then
          make_op
          @op.push current_tk
        else
          while (@op.size > 0) and (priority(@op.last.value) > priority(current_tk.value))
            p = @op.pop
            right = @val.pop
            left = @val.pop
            @val.push Statement.bin_op(op,left,right)
          end
          @op.push current_tk
        end
      when :COMPARER
        make_comp
        @comp.push current_tk
      when :BOOLEAN_OP
        make_boole
        @bool.push current_tk
      else
        current_tk.unexpected
    end
    return :state0_1
  end
  
  # it parses a simple expression (see #expression)
  #
  # * **argument**: symbol. it specifies the end-token of the simple expression
  # * **argument**: string (nil default). it specifyes the value of the
  # end-token of the simple expression. (specific argument to identify keywords)
  # * **returns**: see #expression 
  def simple_exp(eor = :EOL,spec = nil)
     st = state0_1(0)
     forward unless previous_tk.tag == :QUOTES
     while current_tk.tag != eor and current_tk.value != spec
       st = self.send(st)
       forward unless previous_tk.tag == :QUOTES and st == :state2
     end
     previous_tk.meets_eol if st == :state0_1 and current_tk.tag == :EOL
     previous_tk.meets_token(current_tk) if st == :state0_1
     make_boole
     return @val.pop if @val.size > 0
     return nil
  end
  
  # It parses a sring when a :QUOTES token is found;
  #
  # * **returns**: string statement (hash)
  def string
    str = ""
    skip_token :QUOTES
    while current_tk.tag != :QUOTES and current_tk.tag != :EOF
      if current_tk.tag == :SPACE then
        str += " "
      else
        str += current_tk.value.to_s
      end
      forward
    end
    current_tk.meets_eof("string") if current_tk.tag == :EOF
    skip_token :QUOTES
    return Statement.string(str)
  end
  
  # It parses the arguments surrounded by brackets of void, void call
  # print and printl. Arguments are separated by `,`
  #
  # * **argument**: left token value (string) that surrounds the arguments
  # * **argument**: right token value (string) the surrounds the arguments
  # * **argument**: bolean to identify a void call
  # * **returns**: array of arguments
  def surrounded(left,right,call = false)
    skip_token left
    args = []
    while current_tk.value != right
      if call then
        current_tk.wrong(right) unless [:NUMBER,:VARIABLE,:QUOTES].include? current_tk.tag 
        args << current_tk unless current_tk.tag == :QUOTES
        args << string if current_tk.tag == :QUOTES
      else
        current_tk.wrong(right) unless current_tk.tag == :VARIABLE
        args << current_tk     
      end
      forward unless previous_tk.tag == :QUOTES
      current_tk.wrong(")") if current_tk.tag == :COMMA and next_tk.tag == :R_PAR
      skip_token(:COMMA) if current_tk.tag == :COMMA
    end
    skip_token(")")
    return args
  end
  
  # it parses a boolean keyword
  #
  # * **returns**: boolean statement (hash)
  def boolean
    return Statement.boolean(current_tk)
  end
  
  # it psrses print(l) keyword arguments
  #
  # * **returns**: print statement (hash) if the keyword is `print`;
  # printl statement (hash) else
  def print_
    if current_tk.value == "print" then
      skip_token("print")
      return Statement.print(surrounded("(",")",true))
    else
      skip_token("printl")
      return Statement.printl(surrounded("(",")",true))
    end
  end
  
  # it parses the arguments of the keyword `return`
  #
  # * **returns**: return_statement (hash)
  def return_
    skip_token("return")
    return Statement.return_statement(simple_exp)
  end
  
  # it parses the loop structures (do while;end, do;until)
  #
  # * **returns** while_statement (hash) if a while structure has been parsed;
  # until_statement_else
  def loop
    skip_token("do")
    if current_tk.value == "while" then
      skip_token("while")
      condition = simple_exp(:EOL,"{")
      bk = block
      return Statement.while_statement(condition,bk)     
    else
      bk = block(true)
      skip_token("until")
      condition = simple_exp
      return Statement.until_statement(condition,bk)
    end
  end
  
  # it parses a void structure
  #
  # * **returns**: void statement (hash)
  def void
    @return = true
    skip_token("void")
    name = current_tk
    forward
    args = surrounded("(",")")
    bk = block(false)
    @return = false
    return Statement.void(name,args,bk)
  end
 private
   
  # it returns the next token of the stream
  #
  # * *returns**: Token object
  def next_tk
    return @stream[@i+1]
  end
  
  # it returns the current token of the stream
  #
  # * *returns**: Token object
  def current_tk
    return @stream[@i]
  end
  
  # it returns the current token of the stream
  #
  # * *returns**: Token object
  def previous_tk
    return @stream[@i-1]
  end
  
  # it moves the stream pointer of one step forward
  #  
  def forward
    @i += 1
  end  
  
  # it skips the specified token.
  # it throws an error if the current token does non match
  #
  # * **argument**: token tag or value of the token we want to skip;
  def skip_token(tk)
    if tk.is_a? Symbol
      current_tk.wrong(tk.to_s) unless current_tk.tag == tk
    else
      current_tk.wrong(tk) unless current_tk.value == tk
    end
    forward
  end

  # operator priority
  #
  # * **argument**: operator (string)
  # * **returns**: priority number (Fixnum)
  def priority(op)
   case op
     when "+","-"
       return 1
     when "*","/"
       return 2
     when "^"
       return 3
   end
 end
 
 # * **returns**: true if the pointer is out of the stream; false else
 def end_of_stream
   @i < @stream.size ? false : true
 end

end























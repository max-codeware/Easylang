#! /usr/bin/env ruby

require_relative "Errors"
require_relative "My_classes.rb"

module Token

  VARIABLE      = /[a-zA-Z_][a-zA-Z0-9_]*/
  GREATER_EQUAL = /\>=/
  SMALLER_EQUAL = /\<=/
  COMPARE       = /\==/
  GREATER       = /\>/
  SMALLER       = /\</
  DIFFERENT     = /\!=/
  KEYWORDS      = [
                    "if", 
                    "then", 
                    "else", 
                    "end", 
                    "void", 
                    "print", 
                    "printl", 
                    "false", 
                    "true", 
                    "do", 
                    "until", 
                    "while",
                    "return"
                  ]
                  
  def self.generate(line_txt,line_n,col_n,val,spec = "")
    tk = Token.new(line_txt,line_n)
    tk.column = (col_n)
    tk.value = (val)
    unless spec == ""
      tk.tag = spec
      return tk
    end
    case val.downcase
      when COMPARE,GREATER,SMALLER,SMALLER_EQUAL,GREATER_EQUAL,DIFFERENT 
        tk.tag = :COMPARER
      when "="
        tk.tag = :ASSIGN
      when "+","-"
        tk.tag = :SUM_OP
      when "%","*","/"
        tk.tag = :MUL_OP
      when /\^/
        tk.tag = :POWER
      when "!","&&","||"
        tk.tag = :BOOLEAN_OP
      when "("
        tk.tag = :L_PAR
      when ")"
        tk.tag = :R_PAR
      when "{"
        tk.tag = :L_BRACE
      when "}"
        tk.tag = :R_BRACE
      when ","
        tk.tag = :COMMA
      when "+=","-="
        tk.tag = :INCRISE_OP
      when "*=","/=","%="
        tk.tag = :MULTIPLY
      when "^="
        tk.tag = :TO_POWER
      when "\""
        tk.tag = :QUOTES
      when "\n", ";"
        tk.tag = :EOL
      when /\\s/
        tk.tag = :SPACE
      else
        if KEYWORDS.include?(val) then
          tk.tag = :KEYWORD
        elsif VARIABLE.match(val).to_s.size == val.size then
          tk.tag = :VARIABLE
        elsif val.number? then
          tk.tag = :NUMBER
          tk.value = tk.value.to_n
        else
          tk.tag = :UNKNOWN
        end
    end
    return tk
  end
  
  class Line
    def initialize(line_txt,line_n)
      @line_txt = line_txt
      @line_n   = line_n
    end
    
    def line 
      return @line_n
    end
    
    def context
      return @line_txt
    end
  end
  
  class Column < Line
    
    def Column.new(line_txt,line_n)
      super
    end
    
    def column=(pos)
      @pos = pos
    end
    
    def column
      return @pos
    end
    
  end
  
  class Token < Column
  
    def Token.new(line_txt,line_n)
      super
    end
    
    def tag=(tag)
      @tag = tag
    end
    
    def tag
      return @tag
    end
    
    def value=(value)
      @value = value
    end
    
    def value
      return @value
    end
    
    def unexpected
      if self.tag == :KEYWORD
        Error.unexpected_keyword(self)
      else
        Error.unexpected_token(self)
      end
    end
    
    def wrong(tag)
      Error.wrong_token_found(tag,self)
    end
    
    def unknown
      Error.unknown_token(self)
    end
    
    def meets_eol
      Error.op_meets_eol(self)
    end
    
    def meets_token(token)
      Error.op_meets_token(self,token)
    end
    
    def meets_eof(arg)
      Error.token_meets_eof(self,arg)
    end
        
    def to_s
      puts "#{[self.tag,self.column,self.value]}"
    end

  end
  
end




















#! /usr/bin/env ruby

require_relative "Environment.rb"

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Number
  # * **argument**: number token
  def initialize(tk)
    @tk = tk
  end
  
  # * **argument**: Environment object
  # * **returns**: numeric value 
  def evaluate(environment)
    return @tk.value
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Variable
  # * **argument**: variable token
  def initialize(name)
    @tk = tk
  end
  
  # * **argument**: Environment object
  # * **returns**: variable name
  def evaluate(environment)
    return @tk.value
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Program
  # * **argument**: instrutions (program)
  def initialize(instructions)
    @inst = instructions
  end
  
  # * **argument**: Environment object
  def run(environment)
    @inst.each do |inst|
      inst.evaluate(environment)
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SString
  
  # * **argument**: string content
  def initialize(string)
    @me = string
  end
  
  # * **argument**: Environment object
  # * **returns**: string
  def evaluate(environment)
    return @me
  end
  
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Boolean
  
  # * **argument**: boolean token
  def initialize(tk)
    @tk = tk
  end
  
  # * **argument**: Environment object
  # * **returns**: boolean value
  def evaluate(environment)
    @tk.value == "true" ? true : false
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Block
  
  # * **argument**: boby
  def initialize(body)
    @body = body
  end
  
  # * **argument**: Environment object
  def evaluate(env)
    @body.each do |inst|
      inst.evaluate(env)
      break if inst.is_a? Return
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class If
  
  # * **argument**: condition
  # * **argument**: then branch
  # * **argument**: else branch (optional)
  def initialize(cond,_then,_else = nil)
    @cond = cond
    @then = _then
    @else = _else
  end
  
  def evaluate(env)
    if @cond.evaluate(env) then
      @then.evaluate(env)
    else
      @else.evaluate(env) if @else
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class BinOp
  
  # * **argument**: left value of the binary operation
  # * **argument**: right value of the binary operation
  # * **argument**: line number
  def initialize(left,right,line)
    @left  = left
    @right = right
    @line_n = line
  end
  
  # * **returns**: left value
  def left
    return @left
  end
  
  # * **returns**: right value
  def right
    return @right
  end
  
  def line
    return @line
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Sum < BinOp
  
  # * **argument**: see BinOp
  def initialize(l,r,ln)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of sum operation
  def evaluate(env)
    left = self.left.evaluate(env) 
    right =self.right.evaluate(env)
    if left.is_a? Numeric and right.is_a? Numeric then
      return left + right
    else
      raise "  Math Error: cannot sum #{left.class} with #{right.class}\nFrom line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Diff < BinOp

  # * **argument**: see BinOp
  def initialize(l,r,ln)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of diff operation
  def evaluate(env)
    left = self.left.evaluate(env) 
    right =self.right.evaluate(env)
    if left.is_a? Numeric and right.is_a? Numeric then
      return left - right
    else
      raise "  Math Error: cannot subtract #{right.class} to #{left.class}\nFrom line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Mul < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of mul operation
  def evaluate(env)
    left = self.left.evaluate(env) 
    right =self.right.evaluate(env)
    if (left.is_a? Numeric or left.is_a? String) && (right.is_a? Numeric or right.is_a? String) then
      return left - right
    else
      raise "  Math Error: cannot multiply #{left.class} with #{right.class}\nFrom line: #{self.line}"
    end
  end

end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Div < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of div operation
  def evaluate(env)
    left = self.left.evaluate(env) 
    right =self.right.evaluate(env)
    if left.is_a? Numeric and right.is_a? Numeric then
      return left - right
    else
      raise "  Math Error: cannot divide #{left.class} for #{right.class}\nFrom line: #{self.line}"
    end
  end

end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Pow < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of sum operation
  def evaluate(env)
    left = self.left.evaluate(env) 
    right =self.right.evaluate(env)
    if left.is_a? Numeric and right.is_a? Numeric then
      return left - right
    else
      raise "  Math Error: cannot elevate #{left.class} to #{right.class}\nFrom line: #{self.line}"
    end
  end

end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Void

  def initialize(tk,block,args)
    @tk    = tk
    @block = block
    @args  = args
  end
  
  def evaluate(*env)
    env.set_void(@tk,self)
  end
  
  def execute(args)
    raise "  Wrong number of arguments for #{tk.value}: #{@args.size} expected but #{args.size} found" +
    "\nFrom line: #{tk.line}"
    my_env = Environment.new
    for i in 0...@args.size do
      my_env.set_var(@args[i].value,arg[i])
    end
    return block.evaluate(my_env)
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Call
  
  def initialize(tk,args)
    @tk = tk
    @args = args
  end
  
  def evaluate(env)
    void = env.get_void(@tk)
    @args.map! do |arg|
      if arg.tag == :VARIABLE then
        env.get_var(arg)
      elsif arg.is_a? SString
        arg.evaluate(env)
      else
        arg.value
      end
    end
    void.execute(@args)
  end
end


##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class While


  def initialize(cond,block)
    @cond = cond
    @block = block
  end
  
  def evaluate(env)
    while cond.evaluate(env)
      block.evaluete(env)
    end
  end
end


##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Until
 
  def initialize(cond,block)
    @cond = cond
    @block = block
  end
  
  def evaluate(env)
    begin
      @block.evaluate(env)
    end until @cond.evaluate(env) 
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Greater < BinOp
  def initialize(l,r,ln)
    super
  end
  
  def evaluate(env)
    my_left = self.left.evaluate(env)
    my_right = self.right.evaluate(env)
    if my_left.is_a? Numeric and my_right.is_a? Numeric then
      return (my_left > my_right) ? true : false
    else
      raise "  Argument Error: cannot compare #{my_left.class} with #{my_right.class}" +
      "\n From line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Smaller < BinOp
  def initialize(l,r,ln)
    super
  end
  
  def evaluate(env)
    my_left = self.left.evaluate(env)
    my_right = self.right.evaluate(env)
    if my_left.is_a? Numeric and my_right.is_a? Numeric then
      return (my_left < my_right) ? true : false
    else
      raise "  Argument Error: cannot compare #{my_left.class} with #{my_right.class}" +
      "\n From line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class GreaterEq < BinOp
  def initialize(l,r,ln)
    super
  end
  
  def evaluate(env)
    my_left = self.left.evaluate(env)
    my_right = self.right.evaluate(env)
    if my_left.is_a? Numeric and my_right.is_a? Numeric then
      return (my_left >= my_right) ? true : false
    else
      raise "  Argument Error: cannot compare #{my_left.class} with #{my_right.class}" +
      "\n From line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SmallerEq < BinOp
  def initialize(l,r,ln)
    super
  end
  
  def evaluate(env)
    my_left = self.left.evaluate(env)
    my_right = self.right.evaluate(env)
    if my_left.is_a? Numeric and my_right.is_a? Numeric then
      return (my_left <= my_right) ? true : false
    else
      raise "  Argument Error: cannot compare #{my_left.class} with #{my_right.class}" +
      "\n From line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Equal < BinOp
  def initialize(l,r,ln)
    super
  end
  
  def evaluate(env)
    my_left = self.left.evaluate(env)
    my_right = self.right.evaluate(env)
    if my_left.is_a? Numeric and my_right.is_a? Numeric then
      return (my_left == my_right) ? true : false
    else
      raise "  Argument Error: cannot compare #{my_left.class} with #{my_right.class}" +
      "\n From line: #{self.line}"
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class And < BinOp

end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Or < BinOp

end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Not

end







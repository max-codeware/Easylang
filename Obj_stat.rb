#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Number
  # * **argument**: number value
  def initialize(n)
    @n = n
  end
  
  # * **argument**: Environment object
  # * **returns**: number value 
  def evaluate(environment)
    return @n
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Variable
  # * **argument**: variable name
  def initialize(name)
    @name = name
  end
  
  # * **argument**: Environment object
  # * **returns**: variable value
  def evaluate(environment)
    return environment.get_var(@name)
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
      instevaluate(environment)
    end
  end
end

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class String
  
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
  
  # * **argument**: boolean value
  def initialize(value)
    @val = val
  end
  
  # * **argument**: Environment object
  # * **returns**:
  def evaluate(environment)
    @val == "true" ? true : false
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

class BinOp
  
  # * **argument**: left value of the binary operation
  # * **argument**: right value of the binary operation
  def initialize(left,right)
    @left  = left
    @right = right
  end
  
  # * **returns**: left value
  def left
    return @left
  end
  
  # * **returns**: right value
  def right
    return @right
  end
end

def Sum < BinOp
  
  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of sum operation
  def evaluate(env)
    return self.left.evaluate(env) + self.right.evaluate(env)
  end
end

def Diff < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of diff operation
  def evaluate(env)
    return self.left.evaluate(env) - self.right.evaluate(env)
  end
end

def Mul < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of mul operation
  def evaluate(env)
    return self.left.evaluate(env) * self.right.evaluate(env)
  end

end

def Div < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of div operation
  def evaluate(env)
    return self.left.evaluate(env) / self.right.evaluate(env)
  end

end

def Pow < BinOp

  # * **argument**: see BinOp
  def initialize(l,r)
    super
  end
  
  # * **argument**: Environment object
  # * **returns**: result of sum operation
  def evaluate(env)
    return self.left.evaluate(env) ^ self.right.evaluate(env)
  end

end

def Void

  def initialize(block)
    @block = block
  end
  
  def evaluate(env)
    return block.evaluate(env)
  end
end












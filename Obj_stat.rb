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
      @else.evaluate(env)
    end
  end
end
















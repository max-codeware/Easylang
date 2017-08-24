#! /usr/bin/env ruby


class Environment

  def initialize()
    @vars = {}
    @voids = {}
  end
  
  def count_vars
    return @vars.size
  end
  
  def count_voids
    return @voids.size
  end
  
  def new_void(name,vars)
    new_name = name + "#{vars.size}"
    if @voids.keys.include? new_name then
      raise RuntimeError, "  Overload Error: void '#{name}' already defined" unless @voids[name].count_vars = vars.size
    end
    environment = Environment.new()
    vars.each do |var|
      environment.new_var(var)
    end
    @voids[new_name] = environment
  end
  
  def new_var(name)
    raise RuntimeError, "  Argument Exception: variable '#{name}' already defined" if @vars.keys.include? name
    @vars[name] = nil
  end
  
  def set_var(name,value = nil)
    @vars[name] = value
  end
  
  def get_var(name)
    raise RuntimeError, "  Runtime Error: local variable '#{name}' not defined" unless @vars.keys.include? name
    return @vars[name]
  end
  
  def get_void(name,num_vars)
    new_name = name + "#{num_vars}"
    raise RuntimeError, "  Runtime Error: void '#{name}' not defined" unless @voids.keys.include? name
    return @voids[new_name]
  end
  
end

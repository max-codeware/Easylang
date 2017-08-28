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
  
  def new_void(tk,void_obj)
    if @voids.keys.include? tk.value then
      raise RuntimeError, "  Overload Error: void '#{tk.value}' already defined\nFrom line: #{tk.line}"
    end
    @voids[tk.value] = void_obj
  end
  
  def new_var(tk)
    raise RuntimeError, "  Argument Exception: variable '#{tk.value}' already defined" +
    "\nFrom line: #{tk.line}\n#{tk.context}\n#{" "*tk.column}" if @vars.keys.include? tk.value
    @vars[tk.value] = nil
  end
  
  def set_var(tk,value = nil)
    @vars[tk.value] = value
  end
  
  def get_var(tk)
    raise RuntimeError, "  Runtime Error: local variable '#{tk.value}' not defined" +
    "\nFrom line: #{tk.line}\n#{tk.context}\n#{" "*tk.column}"unless @vars.keys.include? tk.value
    return @vars[tk.value]
  end
  
  def get_void(tk)
    raise RuntimeError, "  Runtime Error: void '#{ntk.value}' not defined" unless @voids.keys.include? tk.value
    return @voids[tk.value]
  end
  
end

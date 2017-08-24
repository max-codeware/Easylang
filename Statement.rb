#! /usr/bin/env ruby

module Statement

  def self.prog(body)
    return {:type => :prog, :body => body}
  end

  def self.number(val)
    return {:type => :number, :val => val}
  end
  
  def self.variable(name)
    return {:type => :var, :name => name}
  end
  
  def self.string(content)
    return {:type => :string, :content => content}
  end
  
  def self.boolean(val)
    return {:type => :boolean, :val => val}
  end

  def self.block(block)
    return {:type => :block, :body => block}
  end

  def self.bin_op(op,left,right)
    return {:type => :bin_op, :op => op, :left => left, :right => right}
  end
  
  def self.if_statement(cond,_then,_else = nil)
    return {:type => :if, :cond => cond, :then => _then} if _else == nil
    return {:type => :if, :cond => cond, :then => _then, :else => _else}
  end
  
  def self.void(name,vars,block)
    return {:type => :void, :name => name, :vars => vars, :body => block}
  end
  
  def self.while_statement(cond,block)
    return {:type => :while, :cond => cond, :body => block}
  end
  
  def self.until_statement(cond, block)
    return {:type => :until, :cond => cond, :body => block}
  end
  
  def self.logical_op(op,left,right)
    return {:type => :logical_op, :op => op, :left => left, :right => right}
  end
  
  def self.assign(left,right)
    return {:type => :assing, :left => left, :right => right}
  end
  
  def self.comparison(op,left,right)
    return {:type => :comparison, :op => op, :left => left, :right => right}
  end
  
  def self.print(args)
    return {:type => :print, :args => args}
  end
  
  def self.printl(args)
    return {:type => :printl, :args => args}
  end
  
  def self.called(name,vars)
    return {:type => :call, :name => name, :vars => vars}
  end
  
  def self.return_statement(args)
    return  {:type => :return, :args => args}
  end
  
  def self.logical_not(arg)
    return {:type => :not, :arg => arg
    }
  end
  
end









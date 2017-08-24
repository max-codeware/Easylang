#! /usr/bin/env ruby

class String

  def contain?(str)
    raise ArgumentError, '' unless str.is_a? String
    str.each_char do |ch|
      return true if self.include? ch
    end
    return false
    
    rescue ArgumentError
      str = str.to_s
      retry
  end
  
  def contain_all?(str)
    raise ArgumentError, '' unless str.is_a? String
    str.each_char do |ch|
      return false if not self.include? ch
    end
    return true
    rescue ArgumentError
      str = str.to_s
      retry
  end
  
  def compact()
    nstr = ''
    self.each_char do |ch|
      nstr += ch if ch != ' '
    end
    return nstr
  end
  
  def -(str)
    myStr = str.to_s
    temp = ''
    i = 0
    if self.include? myStr then
      while i < self.length do
        if self[i...(i + myStr.size)] == myStr then
          i += myStr.size
        else
          temp += self[i]
          i += 1
        end
      end
    else
      return self
    end
    return temp
  end
  
  def integer?
    [                          # In descending order of likeliness:
      /^[-+]?[1-9]([0-9]*)?$/, # decimal
      /^0[0-7]+$/,             # octal
      /^0x[0-9A-Fa-f]+$/,      # hexadecimal
      /^0b[01]+$/,             # binary
      /[0]/                     # zero
    ].each do |match_pattern|
      return true if self =~ match_pattern
    end
    return false
  end

  def float?
    pat = /^[-+]?[1-9]([0-9]*)?\.[0-9]+$/
    return true if self=~pat 
    return false 
  end
  
  def number?
    (self.integer? or self.float?) ? (return true) : (return false)
  end

  def to_n
    return self.to_f if self.float?
    return self.to_i if self.integer? 
  end
  
  def remove(index)
    return self if index < 0
    n_str = ''
    for i in 0...self.size
      n_str += self[i] unless i == index
    end
    return n_str
  end
end

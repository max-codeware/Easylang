#! /usr/bin/env ruby
#require "pry-byebug"
require_relative "Token.rb"

class Lexer
  OPERATORS  = [
                  "+","-","*","/","^",
                  "%",">","<","=","\\"
               ] 
  LOGICAL    = [
                  "&","!","|"
               ]
  OTHER_CHAR = [
                  ";","(",")","{","}",",",
                  "\n","\""," "
               ]
  TOKENIZERS = OPERATORS + LOGICAL + OTHER_CHAR
               
  def initialize
    @i = 0
    @string = ""
  end
  
  def scan(filename)
    raise ArgumentError, "Invalid path \"#{filename}\"" unless File.exist?(filename)
    stream = []
    @k = 1
    File.open(filename, "r").each_line do |line|
      unless line[0] == "#" or line == "\n"
        @i = 0
        @string = skip_indent(line)        
        stream += tokenize
      end
      @k += 1
    end
    stream << Token.generate("",@k,0,"",:EOF)
    return stream
  end

  def tokenize()
    temp = ""
    stream = []
    while @i < @string.size
      unless (@string == "")
        if TOKENIZERS.include? @string[@i] then
          stream << Token.generate(@string,@k,@i-temp.size,temp) unless temp == ""
          temp = ""
          if OPERATORS.include? @string[@i] then
            if next_char == "=" then
              op = @string[@i] + step_forward
              stream << Token.generate(@string,@k,@i-1,op)
            elsif @string[@i] == "\\" and next_char == "s" then
              space = @string[@i] + step_forward
              stream << Token.generate(@string,@k,@i,space)
            else
              stream << Token.generate(@string,@k,@i,@string[@i])
            end
          elsif LOGICAL.include? @string[@i]
            if next_char == @string[@i] then
              op = @string[@i] + step_forward
              stream << Token.generate(@string,@k,@i,op)
            else
              stream << Token.generate(@string,@k,@i,@string[@i])
            end
          elsif @string[@i] == "\"" then
            stream << Token.generate(@string,@k,@i,@string[@i])
#            stream << Token.generate(@string,@k,@i+1,get_string,"STRING")
#            stream << Token.generate(@string,@k,@i+1,@string[@i+1]) if @string[@i+1] == "\""
#            @i += 1 if @string[@i+1] == "\""
          else
            stream << Token.generate(@string,@k,@i,@string[@i]) unless @string[@i] == " "
#            step_forward if @string[@i] == ";"
          end
        else
          temp += @string[@i]
        end
      end
      @i += 1
    end
    stream << Token.generate(@string,@k,@i-temp.size,temp) if temp != ""
    return stream
  end
  
 private
 
  
  def next_char
    return @string[@i+1]
  end
  
  def step_forward
    @i += 1
    return @string[@i]
  end
  
  def skip_indent(string)
    raise ArgumentError, "Expecting string but #{string.class found}" unless string.is_a? String
    exit 0 unless string.is_a? String
    i = 0
    while string[i] == " " and i < string.size
      i += 1
    end
    return string[i...string.size]
  end
#binding.pry  
end








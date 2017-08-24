#! /usr/bin/env ruby

module Error


  def self.throw_error(error, line_n, col_n, text)
    puts error
    puts "In line: #{line_n}"
    puts text
    puts (" " * col_n) + "^"
    exit 0
  end
  
  def self.wrong_token_found(tag,token)
    error = "  Sintax Error: expecting '#{tag}' token but #{token.tag} "
    error += (token.tag == :EOL) ? (" \"\"") : ("\"#{token.value}\"") 
    error += " found"
    self.throw_error(error,token.line,token.column,token.context)
  end
  
  def self.unexpected_keyword(token)
    error = "  Sintax Error: unexpected keyword \"#{token.value}\" found"
   self.throw_error(error,token.line,token.column,token.context)
  end

  def self.unknown_token(token)
    error = "  Sintax Error: unknown token \"#{token.value}\" found"
    self.throw_error(error,token.line,token.column,token.context)
  end
  
  def self.unexpected_token(token)
    error = "  Sintax Error: unexpected #{token.tag} token "
    error += (token.tag == :EOL) ? (" \"\"") : ("\"#{token.value}\"")
    self.throw_error(error,token.line,token.column,token.context)
  end
  
  def self.op_meets_eol(token)
    error = "  Sintax Error: operator \"#{token.value}\" meets end of line"
    self.throw_error(error,token.line,token.column,token.context)
  end
  
  def self.op_meets_token(token1,token2)
    error = "  Sintax Error: operator \"#{token1.value}\" meets #{token2.tag} \"#{token2.value}\" token"
    self.throw_error(error,token1.line,token1.column,token1.context)
  end
  
  def self.token_meets_eof(token,arg)
    error = "  Sintax Error: #{arg} meets end of file"
    self.throw_error(error,token.line,token.column,token.context)
  end

end














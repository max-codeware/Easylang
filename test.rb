#! /usr/bin/env ruby


#load './Lexer.rb'
require_relative "Lexer.rb"
require_relative "Environment.rb"
require_relative "Parser.rb"

path = File.realpath(ARGV[0])
lexer = Lexer.new
stream = lexer.scan(path)
=begin
stream.each do |tk|
    tk.show
end


env = Environment.new
begin
  env.new_var("a")
  env.new_var("a")
rescue => error
  puts "#{error}\n#{error.backtrace}";gets
end
=end
parser = Parser.new
statements = parser.parse(stream)
puts statements


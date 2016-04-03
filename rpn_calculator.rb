require_relative './lib/interpreter'

class RpnCalculator
  attr_accessor :prompt
  attr_reader   :interpreter

  def initialize
    @prompt = 'rpn-calculator> '
  end

  def start_repl
    @interpreter = Interpreter.new
    print @prompt
    loop do
      input = STDIN.gets
      break if input.nil? || input.chomp == 'q'
      puts @interpreter.evaluate(input.chomp)
      print @prompt
    end
  end
end

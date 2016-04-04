require_relative './lib/interpreter'

class RpnCalculator
  attr_accessor :prompt
  attr_reader   :interpreter

  USAGE = <<-END
************************************************
*              RPN Calculator                  *
*                 v0.0.1                       *
************************************************

q or Ctrl-D to quit.
  END

  USAGE.freeze
  def initialize
    @prompt = 'rpn-calculator> '
  end

  def start_repl
    puts USAGE
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

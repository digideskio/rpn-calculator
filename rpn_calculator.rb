require_relative './lib/interpreter'

class RpnCalculator
  attr_accessor :prompt, :result
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
    @interpreter = Interpreter.new
    @result = nil
  end

  def start_repl
    print_usage
    loop do
      prompt_and_result
      @result = evaluate
      break if @result == :break
    end
  end

  # Ctrl-D normally signifies EOF, but it appears
  # that STDIN.gets is set to `nil` when this is entered.
  def evaluate
    input = STDIN.gets
    return :break if input.nil? || input.chomp == 'q'
    @interpreter.evaluate(input.chomp)
  end

  def prompt_and_result
    puts @result if @result
    print @prompt
  end

  def print_usage
    puts USAGE
  end
end

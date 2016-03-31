class RpnCalculator
  attr_reader :prompt

  def initialize
    @prompt = 'rpn-calculator> '
    @operand_stack = []
  end

  def start_repl
    print @prompt
    input = gets
    loop do
      break if input.chomp == 'q'
      evaluate(input)
      puts input
      print @prompt
      input = gets
    end
  end

  # Valid input can be either a single number or operand, e.g. '1'
  # or an expression, such as '3 4 + 1 -'
  # Anything other than numbers and the four basic arithmetic operands (+, -, *, /)
  # will be ignored.
  # Assumption: Each operand will be surrounded by spaces, i.e. "1 3+2+ 1-" would not be valid
  # despite being an interpretable expression.
  def evaluate(input)

  end
end

rpn = RpnCalculator.new
rpn.start_repl

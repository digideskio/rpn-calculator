class RpnCalculator
  attr_reader :prompt

  def initialize
    @prompt = 'rpn-calculator> '
    @operand_stack = []
  end
end

rpn = RpnCalculator.new
print rpn.prompt
input = gets
loop do
  break if input.chomp == 'q'
  puts input
  print rpn.prompt
  input = gets
end

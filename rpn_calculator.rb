class RpnCalculator
  attr_reader :prompt

  # module OPERATORS
  #   OP_ADD      = :+
  #   OP_SUB      = :-
  #   OP_MULTIPLY = :*
  #   OP_DIVIDE   = :/
  #   OP_FDIVIDE  = :fdiv
  # end

  OPERATORS = %w(+ - * /)

  def initialize
    @prompt = 'rpn-calculator> '
    @operand_stack = []
  end

  def start_repl
    print @prompt
    input = gets
    loop do
      break if input.chomp == 'q'
      puts "RECEIVED: #{input}"
      puts evaluate(input.chomp)
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
    input.each_char do |c|
      next if c == ' '
      if OPERATORS.include?(c)
        if @operand_stack.length > 1
          operand_2 = @operand_stack.pop
          operand_1 = @operand_stack.pop
          result = operand_1.send(c.to_sym, operand_2)
          @operand_stack.push(result)
        end
      else
        @operand_stack.push(c.to_i)
      end
    end

    @operand_stack.pop
  end
end

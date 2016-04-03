class Interpreter
  attr_accessor :current_char, :current_position, :input

  # Include unicode operators in case expressions are copy-pasted from somewhere
  # that is using actual minus signs instead of hyphens, for example.
  TOKEN_ADD      = ['+', "\u002B"]
  TOKEN_SUB      = ['-', "\u2212"]
  TOKEN_MULTIPLY = ['*', "\u00D7"]
  TOKEN_DIVIDE   = ['/', "\u00F7"]

  OPERATORS = [TOKEN_ADD, TOKEN_SUB, TOKEN_DIVIDE, TOKEN_MULTIPLY].flatten

  END_OF_INPUT = nil

  def initialize(input: '')
    @operand_stack = []
    @input = input.chomp
    @current_position = 0
    @current_char = @input[@current_position]
  end

  # Valid input can be either a single number or operand, e.g. '1'
  # or an expression, such as '3 4 + 1 -'
  # Anything other than numbers and the four basic arithmetic operands (+, -, *, /)
  # will be ignored.
  def evaluate(input)
    reset_input(input)
    while @current_char != END_OF_INPUT
      if space?(@current_char)
        next_char
        next
      end

      if OPERATORS.include?(@current_char)
        if negative_number?
          next_char
          operand = number(negative: true)
          @operand_stack.push(operand)
        elsif @operand_stack.length > 1
          operand_2 = @operand_stack.pop
          operand_1 = @operand_stack.pop
          begin
            result = calculate(operand_1, operand_2, @current_char)
          rescue ZeroDivisionError => e
            puts "Error: #{e}"
            puts "Aborting calculation and resettting stack."
            abort_eval && break
          end

          @operand_stack.push(result)
        end
      else
        @operand_stack.push(number)
      end

      next_char
    end

    @operand_stack.last
  end

  # Instead of encoding the negativeness of a number in this method,
  # it should probably be part of another class, maybe 'Token'.
  def number(negative: false)
    result = ''
    result << '-' if negative

    while !@current_char.nil? && (numeric?(@current_char) || @current_char == '.')
      result << @current_char
      next_char
    end

    begin
      return Integer(result)
    rescue ArgumentError
      return Float(result)
    rescue ArgumentError
      raise StandardError, 'Invalid number'
    end
  end

  private

  def next_char
    @current_position += 1
    update_current_character
  end

  def update_current_character
    if @current_position >= @input.length
      @current_char = END_OF_INPUT
    else
      @current_char = @input[@current_position]
    end
  end

  # This might be overkill, but I ran into an issue with unicode
  # operators from a copy/pasted expression breaking my calculation
  # function and this seemed like the easiest way to guard against
  # that. It's unlikely that anyone would be entering unicode division
  # or multiplication symbols, but it's very hard to tell the
  # difference between a hyphen and a unicode minus sign when copying
  # expressions!
  def calculate(op1, op2, operator)
    if TOKEN_ADD.include?(operator)
      operator = :+
    elsif TOKEN_SUB.include?(operator)
      operator = :-
    elsif TOKEN_DIVIDE.include?(operator)
      raise ZeroDivisionError, 'Attempted to divide by zero!' if op2 == 0
      operator = :/
    elsif TOKEN_MULTIPLY.include?(operator)
      operator = :*
    end

    op1.send(operator, op2)
  end

  # Check if the given value is the start of a negative number
  # by looking for a digit after the minus sign
  def negative_number?
    TOKEN_SUB.include?(@current_char) && numeric?(peek)
  end

  # Return the character after our current position, or END_OF_INPUT if
  # we are trying to read beyond our input.
  def peek
    return @input[@current_position + 1] if @current_position + 1 < @input.length

    END_OF_INPUT
  end

  def space?(input)
    input == ' '
  end

  # This could be implemented as a core extension to String, which would
  # improve readability when its used in methods, e.g. numeric?(peek(input)) vs.
  # peek(input).numeric?
  def numeric?(input)
    begin
      Float(input) != nil
    rescue
      return false
    end
  end

  def reset_input(input)
    self.input = input
    self.current_position = 0
    self.current_char = @input[@current_position]
  end

  def abort_eval
    @operand_stack = []
  end
end

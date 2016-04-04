class Interpreter
  attr_accessor :current_char, :current_position, :input, :operand_stack

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
          operand = to_number(character: @current_char, negative: true)
          @operand_stack.push(operand)
        elsif @operand_stack.length > 1
          operand_2 = @operand_stack.pop
          operand_1 = @operand_stack.pop
          begin
            result = calculate(operand_1, operand_2, @current_char)
          rescue ZeroDivisionError => e
            log_error(e.message)
            abort_eval && break
          end

          @operand_stack.push(result)
        end
      elsif numeric?(@current_char)
        @operand_stack.push(to_number(character: @current_char))
      else
        # We've encounter a character that isn't an operator
        # and cannot be interpreted as a number, so we're going
        # to abort our evaluation.
        log_error("Unsupported operand \"#{@current_char}\"")
        abort_eval && break
      end

      next_char
    end

    # Return the top of stack without popping it off
    @operand_stack.last
  end

  def input=(new_input)
    reset_input(new_input)
  end

  def log_error(error)
    puts "Error: #{error}"
  end

  private

  def next_char
    @current_position += 1
    update_current_character
  end

  def update_current_character
    @current_char = if @current_position >= @input.length
                      END_OF_INPUT
                    else
                      @input[@current_position]
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
      raise ZeroDivisionError, 'Attempted to divide by zero! Aborting calculation and resetting stack.' if op2 == 0
      operator = correct_division_operator(op1, op2)
    elsif TOKEN_MULTIPLY.include?(operator)
      operator = :*
    end

    op1.send(operator, op2)
  end

  # If the first operand is evenly divisible by the second,
  # do integer division. Otherwise, or if we're already dealing
  # with floats, do floating point division.
  def correct_division_operator(op1, op2)
    is_float = [op1, op2].any? { |operand| operand.is_a? Float }
    not_evenly_divisible = (op1 % op2 != 0)
    if is_float || not_evenly_divisible
      return :fdiv
    else
      return :/
    end
  end

  # Instead of encoding the negativeness of a number in this method,
  # it should probably be part of another class, such as 'Token'.
  def to_number(character:, negative: false)
    result = ''
    result << '-' if negative

    while !character.nil? && (numeric?(character) || character == '.')
      result << character
      character = next_char
    end

    # Regular expressions would be an alternative to using exceptions
    # as control flow, which is normally a code smell. From searches done
    # online, rescuing a failed cast seems to be the somewhat canonical way
    # to check if a string is an Integer or Float in ruby.
    # TODO: If we somehow fail to cast as a Float, this will crash.
    begin
      return Integer(result)
    rescue ArgumentError
      return Float(result)
    end
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
    @input = input
    self.current_position = 0
    self.current_char = @input[@current_position]
  end

  def abort_eval
    @operand_stack = []
  end
end

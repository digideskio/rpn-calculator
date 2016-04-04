require 'spec_helper'
require 'interpreter'

describe Interpreter do
  let(:interpreter) { Interpreter.new }

  describe 'initialization' do
    it 'has no input' do
      expect(interpreter.input).to eq('')
    end

    it 'sets its current position to 0' do
      expect(interpreter.current_position).to be(0)
    end

    it 'sets its current character to nil' do
      expect(interpreter.current_char).to be(nil)
    end

    it 'has an empty operand stack' do
      expect(interpreter.operand_stack).to eq([])
    end
  end

  describe 'resetting input' do
    it 'resets the character and position pointers' do
      interpreter.input = '2 3 + 5 *'
      expect(interpreter.current_char).to eq('2')
      expect(interpreter.current_position).to eq(0)
      interpreter.input = '4 5 + 10 -'
      expect(interpreter.current_char).to eq('4')
      expect(interpreter.current_position).to eq(0)
    end
  end

  describe 'evaluating input' do
    it 'yields the correct result' do
      # 5 + ((1 + 2) * 4) - 3 => 14
      result = interpreter.evaluate('5 1 2 + 4 * + 3 -')
      expect(result).to eq(14)
    end

    it 'handles negative numbers correctly' do
      result = interpreter.evaluate('2 -1 -')
      expect(result).to eq(3)
    end

    it 'keeps the last result on the stack' do
      interpreter.evaluate('2 3 +')
      result = interpreter.evaluate('5 +')
      expect(result).to eq(10)
    end

    it 'handles operands entered individually' do
      interpreter.evaluate('2')
      interpreter.evaluate('3')
      result = interpreter.evaluate('+')
      expect(result).to eq(5)
    end

    it 'handles floating point numbers' do
      result = interpreter.evaluate('2.0 0.9 -')
      expect(result).to eq(1.1)
    end

    describe 'unsupported operands' do
      before do
        allow(interpreter).to receive(:log_error) { true }
      end

      it 'aborts the calculation' do
        interpreter.evaluate('3 2 - B +')
        expect(interpreter.operand_stack).to eq([])
      end

      it 'passes an error message to the log_error method' do
        expect(interpreter).to receive(:log_error).with('Unsupported operand "B"')
        interpreter.evaluate('3 2 - B +')
      end
    end

    describe 'division special cases' do

      describe 'attempting to divide by zero' do
        before do
          # Stub the log_error method to prevent output.
          # Not the best solution, but this will work for now.
          allow(interpreter).to receive(:log_error) { true }
        end

        it 'logs an error that is displayed to the user' do
          error = ZeroDivisionError.new('Attempted to divide by zero! Aborting calculation and resetting stack.')
          expect(interpreter).to receive(:log_error).with(error.message)
          interpreter.evaluate('5 0 /')
        end

        it 'resets the operand stack' do
          interpreter.evaluate('3 4 +')
          expect(interpreter.operand_stack).to eq([7])
          interpreter.evaluate('5 0 /')

          expect(interpreter.operand_stack).to eq([])
        end
      end

      it 'performs interger division with evenly-divisible operands' do
        result = interpreter.evaluate('8 4 /')
        expect(result).to be_a(Integer)
      end

      it 'performs floating-point division with non evenly-divisible operands' do
        result = interpreter.evaluate('8 3 /')
        expect(result).to be_a(Float)
      end
    end
  end

  describe 'logging error messages to user' do
    it 'outputs error messages to user' do
      error = StandardError.new('An error occurred!')
      expect { interpreter.log_error(error) }
        .to output("Error: An error occurred!\n").to_stdout
    end
  end
end

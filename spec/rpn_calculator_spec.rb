require 'spec_helper'
require './rpn_calculator'

describe RpnCalculator do
  let(:calculator) { RpnCalculator.new }

  describe 'starting the REPL' do
    before do
      # break out of our infinite loop instantly
      allow(calculator).to receive(:evaluate) { :break }
    end

    it 'outputs a usage message' do
      all_output = RpnCalculator::USAGE + calculator.prompt
      expect { calculator.start_repl }.to output(all_output).to_stdout
    end

    context 'repl is running' do
      before do
        allow(calculator).to receive(:print_usage) { true }
        allow(calculator).to receive(:prompt_and_result) { true }
      end

      it 'calls evaluate' do
        expect(calculator).to receive(:evaluate).once
        calculator.start_repl
      end

      it 'prints the result of the evaluation' do
        allow(calculator).to receive(:evaluate).and_return(5, :break)
        expect(calculator).to receive(:prompt_and_result).twice
        calculator.start_repl
      end
    end

  end

  describe 'evaluating user input' do
    let(:interpreter) { calculator.interpreter }
    before do
      allow(calculator.interpreter).to receive(:evaluate) { 5 }
      allow(calculator).to receive(:prompt_and_result) { true }
    end

    it 'passes user input from STDIN to the interpreter' do
      allow(STDIN).to receive(:gets) { '2 3 +' }
      expect(interpreter).to receive(:evaluate).with('2 3 +')
      calculator.evaluate
    end
  end

  describe 'terminating the repl' do
    it 'signals for termination when q is entered' do
      allow(STDIN).to receive(:gets) { 'q' }
      expect(calculator.evaluate).to eq(:break)
    end

    it 'signals for termination when input is nil' do
      allow(STDIN).to receive(:gets) { nil }
      expect(calculator.evaluate).to eq(:break)
    end
  end

  describe 'printing output' do
    it 'prints the result of evaluation' do
      calculator.result = 5
      expect { calculator.prompt_and_result }.to output("5\n#{calculator.prompt}").to_stdout
    end
  end
end

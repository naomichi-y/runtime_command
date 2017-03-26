require 'spec_helper'

module RuntimeCommand
  describe Output do
    describe 'initialize' do
      it 'should be return instance' do
        expect(RuntimeCommand::Output.new).to be_a(RuntimeCommand::Output)
      end
    end

    shared_examples_for 'buffered_stdout' do
      it 'should be necessary to return buffer string' do
        command_output.flash
        command_output.stdout('test')

        expect(command_output.buffered_stdout).to eq('test')
        expect(command_output.buffered_stderr).to be_empty
        expect(command_output.buffered_log).to eq('test')
      end
    end

    shared_examples_for 'buffered_stderr' do
      it 'should be necessary to return buffer string' do
        command_output.flash
        command_output.stderr('test')

        expect(command_output.buffered_stdout).to be_empty
        expect(command_output.buffered_stderr).to eq('test')
        expect(command_output.buffered_log).to eq('test')
      end
    end

    context 'when output is true' do
      let(:command_output) { RuntimeCommand::Output.new(output: true) }

      describe 'stdin' do
        it 'should be output message' do
          expect { command_output.stdin('test') }.to output(/test/).to_stdout
        end
      end

      describe 'stdout' do
        it 'should be output message' do
          expect { command_output.stdout('test') }.to output(/test/).to_stdout
        end

        it_should_behave_like 'buffered_stdout'
      end

      describe 'stderr' do
        it 'should be output message' do
          expect { command_output.stderr('test') }.to output(/test/).to_stdout
        end

        it_should_behave_like 'buffered_stderr'
      end
    end

    context 'when output is false' do
      let(:command_output) { RuntimeCommand::Output.new(output: false) }

      describe 'stdin' do
        it 'should be no output message' do
          expect { command_output.stdin('test') }.to output(/^$/).to_stdout
        end
      end

      describe 'stdout' do
        it 'should be no output message' do
          expect { command_output.stdout('test') }.to output(/^$/).to_stdout
        end

        it_should_behave_like 'buffered_stdout'
      end

      describe 'stderr' do
        it 'should be no output message' do
          expect { command_output.stderr('test') }.to output(/^$/).to_stdout
        end

        it_should_behave_like 'buffered_stderr'
      end
    end
  end
end

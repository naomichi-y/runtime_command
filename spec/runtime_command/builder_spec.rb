require 'spec_helper'

module RuntimeCommand
  describe Builder do
    let(:command) { RuntimeCommand::Builder.new }

    describe 'initialize' do
      it 'should be return instance' do
        expect(command).to be_a(RuntimeCommand::Builder)
      end

      context 'when default options' do
        it 'shuld be return valid options' do
          options = command.instance_variable_get(:@options)

          expect(options[:base_dir]).to eq('.')
          expect(options[:colors]).to eq({})
          expect(options[:logger]).to be_nil
          expect(options[:output]).to be_truthy
          expect(options[:stdin_prefix]).to eq('>')
        end
      end

      context 'when override options' do
        it 'shuld be return valid options' do
          command = RuntimeCommand::Builder.new(
            base_dir: 'base_dir',
            colors: :none,
            logger: Logger.new(STDOUT),
            output: false,
            stdin_prefix: '#'
          )
          options = command.instance_variable_get(:@options)

          expect(options[:base_dir]).to eq('base_dir')
          expect(options[:colors]).to eq(:none)
          expect(options[:logger]).to be_a(Logger)
          expect(options[:output]).to be_falsey
          expect(options[:stdin_prefix]).to eq('#')
        end
      end
    end

    describe 'exec' do
      let(:command_output) { command.exec('command') }

      before do
        allow(command).to receive(:exec).and_return(command_output_mock)
      end

      context 'when output of STDOUT' do
        let(:command_output_mock) do
          double('command_output_mock', buffered_stdout: 'success', buffered_stderr: '', buffered_log: 'success')
        end

        it 'should be return output message' do
          expect(command_output.buffered_stdout).to eq('success')
          expect(command_output.buffered_stderr).to be_empty
          expect(command_output.buffered_log).to eq('success')
        end
      end

      context 'output of STDERR' do
        let(:command_output_mock) do
          double('command_output_mock', buffered_stdout: '', buffered_stderr: 'error', buffered_log: 'error')
        end

        it 'should be return error message' do
          expect(command_output.buffered_stdout).to be_empty
          expect(command_output.buffered_stderr).to eq('error')
          expect(command_output.buffered_log).to eq('error')
        end
      end
    end

    describe 'puts' do
      context 'when string specified' do
        let(:command_output) { command.puts('test') }

        it 'should be return RuntimeCommand::Output' do
          expect(command_output).to be_a(RuntimeCommand::Output)
        end

        it 'should be return input message' do
          expect(command_output.buffered_log).to eq('test')
          expect(command_output.buffered_stdout).to eq('test')
        end

        it 'should be return all input message' do
          command.puts('test')
          command.puts('test')
          expect(command.buffered_log).to eq("test\ntest\n")
        end
      end

      context 'when nil specified' do
        let(:command_output) { command.puts(nil) }

        it 'should be return RuntimeCommand::Output' do
          expect(command_output).to be_a(RuntimeCommand::Output)
        end
      end
    end

    describe 'puts_error' do
      context 'when string specified' do
        let(:command_output) { command.puts_error('test') }

        it 'should be return RuntimeCommand::Output' do
          expect(command_output).to be_a(RuntimeCommand::Output)
        end

        it 'should be return error message' do
          expect(command_output.buffered_log).to eq('test')
          expect(command_output.buffered_stderr).to eq('test')
        end

        it 'should be return all error message' do
          command.puts('test')
          command.puts('test')
          expect(command.buffered_log).to eq("test\ntest\n")
        end
      end

      context 'when nil specified' do
        let(:command_output) { command.puts_error(nil) }

        it 'should be return RuntimeCommand::Output' do
          expect(command_output).to be_a(RuntimeCommand::Output)
        end
      end
    end
  end
end

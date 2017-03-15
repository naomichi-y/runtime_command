require 'spec_helper'

module RuntimeCommand
  describe Builder do
    let(:command) { RuntimeCommand::Builder.new }

    describe 'initialize' do
      it 'should be return instance' do
        expect(command).to be_a(RuntimeCommand::Builder)
      end
    end

    describe 'exec' do
      let(:logger) { command.exec('command') }

      before do
        allow(command).to receive(:exec).and_return(logger_mock)
      end

      context 'output of STDOUT' do
        let(:logger_mock) do
          double('logger_mock', buffered_stdout: 'success', buffered_stderr: '', buffered_log: 'success')
        end

        it 'should be return output message' do
          expect(logger.buffered_stdout).to eq('success')
          expect(logger.buffered_stderr).to be_empty
          expect(logger.buffered_log).to eq('success')
        end
      end

      context 'output of STDERR' do
        let(:logger_mock) do
          double('logger_mock', buffered_stdout: '', buffered_stderr: 'error', buffered_log: 'error')
        end

        it 'should be return error message' do
          expect(logger.buffered_stdout).to be_empty
          expect(logger.buffered_stderr).to eq('error')
          expect(logger.buffered_log).to eq('error')
        end
      end
    end

    describe 'puts' do
      let(:logger) { command.puts('test') }

      it 'should be return input message' do
        expect(logger.buffered_log).to eq('test')
        expect(logger.buffered_stdout).to eq('test')
      end

      it 'should be return all input message' do
        command.puts('test')
        command.puts('test')
        expect(command.buffered_log).to eq("test\ntest\n")
      end
    end

    describe 'puts_error' do
      let(:logger) { command.puts_error('test') }

      it 'should be return error message' do
        expect(logger.buffered_log).to eq('test')
        expect(logger.buffered_stderr).to eq('test')
      end

      it 'should be return all error message' do
        command.puts('test')
        command.puts('test')
        expect(command.buffered_log).to eq("test\ntest\n")
      end
    end
  end
end

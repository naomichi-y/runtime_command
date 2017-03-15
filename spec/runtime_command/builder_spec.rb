require 'spec_helper'

module RuntimeCommand
  describe Builder do
    describe 'initialize' do
      it 'should be return instance' do
        expect(RuntimeCommand::Builder.new).to be_a(RuntimeCommand::Builder)
      end
    end

    describe 'exec' do
      let(:runtime) { RuntimeCommand::Builder.new }
      let(:logger) { runtime.exec('command') }

      before do
        allow(runtime).to receive(:exec).and_return(logger_mock)
      end

      context 'output of STDOUT' do
        let(:logger_mock) do
          double('logger_mock', buffered_stdout: 'success', buffered_stderr: '', buffered_log: 'success')
        end

        it 'should be output message' do
          expect(logger.buffered_stdout).to eq('success')
          expect(logger.buffered_stderr).to be_empty
          expect(logger.buffered_log).to eq('success')
        end
      end

      context 'output of STDERR' do
        let(:logger_mock) do
          double('logger_mock', buffered_stdout: '', buffered_stderr: 'error', buffered_log: 'error')
        end

        it 'should be output message' do
          expect(logger.buffered_stdout).to be_empty
          expect(logger.buffered_stderr).to eq('error')
          expect(logger.buffered_log).to eq('error')
        end
      end
    end
  end
end

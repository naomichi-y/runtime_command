require "spec_helper"

module RuntimeCommand
  describe Builder do
    describe 'initialize' do
      it 'should be return instance' do
        expect(RuntimeCommand::Builder.new).to be_a(RuntimeCommand::Builder)
      end
    end

    describe 'exec' do
      let(:command) { RuntimeCommand::Builder.new }

      context 'output of STDOUT' do
        it 'should be output message' do
          expect(command.exec('echo -n hello').buffered_stdout).to eq('hello')
          expect(command.exec('echo -n hello').buffered_stderr).to be_empty
        end
      end

      context 'output of STDERR' do
        it 'should be output message' do
          expect(command.exec('dummy_command').buffered_stdout).to be_empty
          expect(command.exec('dummy_command').buffered_stderr).not_to be_empty
        end
      end
    end
  end
end

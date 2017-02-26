require "spec_helper"

module RuntimeCommand
  describe Logger do
    describe 'initialize' do
      it 'should be return instance' do
        expect(RuntimeCommand::Logger.new).to be_a(RuntimeCommand::Logger)
      end
    end
  end
end

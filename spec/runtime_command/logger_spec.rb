require "spec_helper"

module RuntimeCommand
  describe Logger do
    let(:logger) { RuntimeCommand::Logger.new }

    describe 'initialize' do
      it 'should be return instance' do
        expect(RuntimeCommand::Logger.new).to be_a(RuntimeCommand::Logger)
      end
    end

    describe 'stdin' do
      it 'should be output message' do
        expect(logger.stdin('test')).to eq("test\n")
      end
    end

    describe 'stdout' do
      it 'should be output message' do
        expect(logger.stdout('test')).to eq('test')

        logger.flash
        logger.stdout('test')

        expect(logger.buffered_stdout).to eq('test')
        expect(logger.buffered_log).to eq('test')
      end
    end

    describe 'stderr' do
      it 'should be output message' do
        expect(logger.stderr('test')).to eq('test')

        logger.flash
        logger.stderr('test')

        expect(logger.buffered_stderr).to eq('test')
        expect(logger.buffered_log).to eq('test')
      end
    end
  end
end

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
        expect { logger.stdin('test') }.to output(/test/).to_stdout
      end
    end

    describe 'stdout' do
      it 'should be output message' do
        expect { logger.stdout('test') }.to output(/test/).to_stdout

        logger.flash
        logger.stdout('test')

        expect(logger.buffered_stdout).to eq('test')
        expect(logger.buffered_stderr).to be_empty
        expect(logger.buffered_log).to eq('test')
      end
    end

    describe 'stderr' do
      it 'should be output message' do
        expect { logger.stderr('test') }.to output(/test/).to_stdout

        logger.flash
        logger.stderr('test')

        expect(logger.buffered_stdout).to be_empty
        expect(logger.buffered_stderr).to eq('test')
        expect(logger.buffered_log).to eq('test')
      end
    end
  end
end

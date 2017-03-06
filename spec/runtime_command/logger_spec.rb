require "spec_helper"

module RuntimeCommand
  describe Logger do
    describe 'initialize' do
      it 'should be return instance' do
        expect(RuntimeCommand::Logger.new).to be_a(RuntimeCommand::Logger)
      end
    end

    shared_examples_for 'buffered_stdout' do
      it 'should be necessary to return buffer string' do
        logger.flash
        logger.stdout('test')

        expect(logger.buffered_stdout).to eq('test')
        expect(logger.buffered_stderr).to be_empty
        expect(logger.buffered_log).to eq('test')
      end
    end

    shared_examples_for 'buffered_stderr' do
      it 'should be necessary to return buffer string' do
        logger.flash
        logger.stderr('test')

        expect(logger.buffered_stdout).to be_empty
        expect(logger.buffered_stderr).to eq('test')
        expect(logger.buffered_log).to eq('test')
      end
    end

    context 'when output is true' do
      let(:logger) { RuntimeCommand::Logger.new(true) }

      describe 'stdin' do
        it 'should be output message' do
          expect { logger.stdin('test') }.to output(/test/).to_stdout
        end
      end

      describe 'stdout' do
        it 'should be output message' do
          expect { logger.stdout('test') }.to output(/test/).to_stdout
        end

        it_should_behave_like 'buffered_stdout'
      end

      describe 'stderr' do
        it 'should be output message' do
          expect { logger.stderr('test') }.to output(/test/).to_stdout
        end

        it_should_behave_like 'buffered_stderr'
      end
    end

    context 'when output is false' do
      let(:logger) { RuntimeCommand::Logger.new(false) }

      describe 'stdin' do
        it 'should be no output message' do
          expect { logger.stdin('test') }.to output(/^$/).to_stdout
        end
      end

      describe 'stdout' do
        it 'should be no output message' do
          expect { logger.stdout('test') }.to output(/^$/).to_stdout
        end

        it_should_behave_like 'buffered_stdout'
      end

      describe 'stderr' do
        it 'should be no output message' do
          expect { logger.stderr('test') }.to output(/^$/).to_stdout
        end

        it_should_behave_like 'buffered_stderr'
      end
    end
  end
end

require 'open3'
require 'runtime_command/logger'

module RuntimeCommand
  class Builder
    attr_reader :buffered_log
    attr_accessor :stdin_prefix, :colors, :output

    # @param [String] base_dir
    # @return [RuntimeCommand::Builder]
    def initialize(base_dir = '.')
      @base_dir = base_dir
      @output = true
      @buffered_log = ''
      @stdin_prefix = '>'
      @colors = {}
    end

    # @param [String] command
    # @param [String] chdir
    # @return [RuntimeCommand::Logger]
    def exec(command, chdir = nil)
      chdir ||= @base_dir

      logger = Logger.new(@output, @colors)
      logger.stdin(@stdin_prefix + ' ' + command)

      begin
        Open3.popen3(command, chdir: chdir) do |stdin, stdout, stderr, wait_thr|
          stdin.close

          stdout.each do |line|
            logger.stdout(line)
          end

          stderr.each do |line|
            logger.stderr(line)
          end
        end

      rescue Interrupt
        logger.stderr('Interrupt error')
      rescue => e
        logger.stderr(e.to_s)
      ensure
        @buffered_log << logger.buffered_log
      end

      logger
    end

    # @param [String] line
    def puts(line)
      logger = Logger.new(@output, @colors)
      logger.stdout(line)

      @buffered_log << logger.buffered_log
      return
    end
  end
end

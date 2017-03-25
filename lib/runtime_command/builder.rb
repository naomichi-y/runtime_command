require 'logger'
require 'open3'
require 'runtime_command/logger'

module RuntimeCommand
  class Builder
    attr_reader :buffered_log

    # @param [Hash] options
    # @option options [String] base_dir
    # @option options [Hash] colors
    # @option options [Logger] logger
    # @option options [Boolean] output
    # @option options [String] stdin_prefix
    # @return [RuntimeCommand::Builder]
    def initialize(options = {})
      options[:base_dir] ||= '.'
      options[:colors] ||= {}
      options[:logger] ||= nil
      options[:output] ||= true
      options[:stdin_prefix] ||= '>'

      @options = options
      @buffered_log = ''
    end

    # @param [String] command
    # @param [String] chdir
    # @return [RuntimeCommand::Logger]
    def exec(command, chdir = nil)
      chdir ||= @options[:base_dir]

      logger = Logger.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])
      logger.stdin(@options[:stdin_prefix] + ' ' + command)

      invoke_command(logger) do
        Open3.popen3(command, chdir: chdir) do |stdin, stdout, stderr|
          stdin.close

          stdout.each do |message|
            logger.stdout(message)
          end

          stderr.each do |message|
            logger.stderr(message)
          end
        end
      end

      logger
    end

    # @param [String] command
    # @param [String] chdir
    # @return [RuntimeCommand::Logger]
    def exec_capture(command, chdir = nil)
      chdir ||= @options[:base_dir]

      logger = Logger.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])
      invoke_command(logger) do
        stdout, stderr = Open3.capture3(command, chdir: chdir)
        logger.stdout(stdout) unless stdout.empty?
        logger.stderr(stderr) unless stderr.empty?
      end

      logger
    end

    # @param [String] message
    # @return [RuntimeCommand::Logger]
    def puts(message)
      logger = Logger.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])
      logger.stdout(message) unless message.nil?

      @buffered_log << logger.buffered_log + "\n"
      logger
    end

    # @param [String] message
    # @return [RuntimeCommand::Logger]
    def puts_error(message)
      logger = Logger.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])
      logger.stderr(message) unless message.nil?

      @buffered_log << logger.buffered_log + "\n"
      logger
    end

    private

    # @param [RuntimeCommand::Logger] logger
    def invoke_command(logger)
      begin
        yield
      rescue Interrupt
        logger.stderr('Interrupt error')
      rescue => e
        logger.stderr(e.to_s)
      ensure
        @buffered_log << logger.buffered_log
      end

      nil
    end
  end
end

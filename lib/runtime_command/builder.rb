require 'logger'
require 'open3'
require 'runtime_command/output'

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
      options[:output] ||= options[:output].nil?
      options[:stdin_prefix] ||= '>'

      @options = options
      @buffered_log = ''
    end

    # @param [String] command
    # @param [String] chdir
    # @return [RuntimeCommand::Output]
    def exec(command, chdir = nil)
      chdir ||= @options[:base_dir]
      logger = Output.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])

      begin
        logger.stdin(@options[:stdin_prefix] + ' ' + command)
        Open3.popen3(command, chdir: chdir) do |stdin, stdout, stderr|
          stdin.close

          stdout.each do |message|
            logger.stdout(message)
          end

          stderr.each do |message|
            logger.stderr(message)
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

    # @param [String] message
    # @return [RuntimeCommand::Output]
    def puts(message)
      logger = Output.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])
      logger.stdout(message) unless message.nil?

      @buffered_log << logger.buffered_log + "\n"
      logger
    end

    # @param [String] message
    # @return [RuntimeCommand::Output]
    def puts_error(message)
      logger = Output.new(output: @options[:output], colors: @options[:colors], logger: @options[:logger])
      logger.stderr(message) unless message.nil?

      @buffered_log << logger.buffered_log + "\n"
      logger
    end
  end
end

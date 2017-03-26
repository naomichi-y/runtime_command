require 'highline'

module RuntimeCommand
  class Output
    attr_reader :buffered_log, :buffered_stdout, :buffered_stderr

    # @param [Hash] options
    # @option options [Hash] colors
    # @option options [Boolean] output
    # @return RuntimeCommand::Logger
    def initialize(options = {})
      @options = options
      @has_color = options[:colors] != :none

      if @has_color
        @stdin_color = options.dig(:colors, :stdin) || HighLine::Style.rgb(204, 204, 0)
        @stdout_color = options.dig(:colors, :stdout) || HighLine::Style.rgb(64, 64, 64)
        @stderr_color = options.dig(:colors, :stderr) || HighLine::Style.rgb(255, 51, 51)
      end

      flash
    end

    # @param [String] line
    def stdin(line)
      puts @has_color ? HighLine.color(line, @stdin_color) : line if @options[:output]

      @options[:logger].info(line) if @options[:logger]
      @buffered_log << line + "\n"

      nil
    end

    # @return [Boolean]
    def stdout?
      !@buffered_stdout.empty?
    end

    # @param [String] line
    def stdout(line)
      trim_line = line.chomp
      puts @has_color ? HighLine.color(trim_line, @stdout_color) : line if @options[:output]

      @options[:logger].info(trim_line) if @options[:logger]
      @buffered_log << line
      @buffered_stdout << line

      nil
    end

    # @return [Boolean]
    def stderr?
      !@buffered_stderr.empty?
    end

    # @param [String] line
    def stderr(line)
      trim_line = line.chomp
      puts @has_color ? HighLine.color(trim_line, @stderr_color) : line if @options[:output]

      @options[:logger].error(trim_line) if @options[:logger]
      @buffered_log << line
      @buffered_stderr << line

      nil
    end

    def flash
      @buffered_log = ''
      @buffered_stdout = ''
      @buffered_stderr = ''

      nil
    end
  end
end

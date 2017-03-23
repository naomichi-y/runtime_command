require 'highline'

module RuntimeCommand
  class Logger
    attr_reader :buffered_log, :buffered_stdout, :buffered_stderr

    # @param [Boolean] output
    # @param [Hash] colors
    # @return RuntimeCommand::Logger
    def initialize(output = true, colors = {})
      @output = output
      @has_color = colors != :none

      if @has_color
        @stdin_color = colors[:stdin] || HighLine::Style.rgb(204, 204, 0)
        @stdout_color = colors[:stdout] || HighLine::Style.rgb(64, 64, 64)
        @stderr_color = colors[:stderr] || HighLine::Style.rgb(255, 51, 51)
      end

      flash
    end

    # @param [String] line
    def stdin(line)
      puts HighLine.color(line, @stdin_color) if @output && @has_color
      puts line if @output && !@has_color

      @buffered_log << line + "\n"

      nil
    end

    # @return [Boolean]
    def stdout?
      !@buffered_stdout.empty?
    end

    # @param [String] line
    def stdout(line)
      puts HighLine.color(line.chomp, @stdout_color) if @output && @has_color
      puts line if @output && !@has_color

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
      puts HighLine.color(line.chomp, @stderr_color) if @output && @has_color
      puts line if @output && !@has_color

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

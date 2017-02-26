module RuntimeCommand
  class Logger
    attr_reader :buffered_log, :buffered_stdout, :buffered_stderr

    def initialize(output = true, colors = nil)
      @output = output

      stdin_rgb = [204, 204, 0]
      stdout_rgb = [64, 64, 64]
      stderr_rgb = [255, 51, 51]

      if colors
        stdin_rgb = colors[:stdin] if colors.has_key?(:stdin)
        stdout_rgb = colors[:stdout] if colors.has_key?(:stdout)
        stderr_rgb = colors[:stderr] if colors.has_key?(:stderr)
      end

      @stdin_color = HighLine::Style.rgb(*stdin_rgb)
      @stdout_color = HighLine::Style.rgb(*stdout_rgb)
      @stderr_color = HighLine::Style.rgb(*stderr_rgb)

      flash
    end

    def stdin(line)
      puts HighLine.color(line, @stdin_color) if @output
      @buffered_log << line + "\n"

      return
    end

    def stdout(line)
      puts HighLine.color(line.chomp, @stdout_color) if @output

      @buffered_log << line
      @buffered_stdout << line

      return
    end

    def stderr(line)
      puts HighLine.color(line.chomp, @stderr_color) if @output

      @buffered_log << line
      @buffered_stderr << line

      return
    end

    def flash
      @buffered_log = ''
      @buffered_stdout = ''
      @buffered_stderr = ''

      return
    end
  end
end

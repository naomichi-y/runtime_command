require 'open3'

module RuntimeCommand
  class Builder
    attr_reader :buffered_log
    attr_accessor :stdin_prefix, :colors, :output

    def initialize(base_dir = '.')
      @base_dir = base_dir
      @output = true
      @buffered_log = ''
      @stdin_prefix = '>'
    end

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

        @buffered_log << logger.buffered_log

      rescue => e
        logger.stderr(e.to_s)
        @buffered_log << logger.buffered_log
      end

      logger
    end
  end
end

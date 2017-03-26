require 'bundler/setup'
require 'runtime_command'

logger = Logger.new('result.log')
logger.formatter = proc do |_severity, _datetime, _progname, msg|
  "#{msg}\n"
end

command = RuntimeCommand::Builder.new(logger: logger)
command.exec('echo "wait 3" sec; sleep 3; echo "hello world!"')

# puts command.exec('ls -la').buffered_stdout

# colors = {
#   stdout: HighLine::Style.rgb(255, 0, 0)
# }
# command = RuntimeCommand::Builder.new(colors: colors)
# command.exec('ls -la')

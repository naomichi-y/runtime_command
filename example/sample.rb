require 'bundler/setup'
require 'runtime_command'

command = RuntimeCommand::Builder.new
# command.colors = :default_colors
command.exec('echo "wait 3" sec; sleep 3; echo "hello world!"')

# command.output = false
# puts command.exec('ls -la').buffered_stdout

# command.colors[:stdout] = HighLine::Style.rgb(255, 0, 0)
# command.exec('ls -la')

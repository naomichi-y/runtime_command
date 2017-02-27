require "bundler/setup"
require "runtime_command"

command = RuntimeCommand::Builder.new
command.exec('echo "wait 3" sec; sleep 3; echo "hello world!"')

require 'runtime_command/version'
require 'runtime_command/builder'

module RuntimeCommand
  def self.builder
    RuntimeCommand::Builder.new
  end
end

require 'runtime_command/version'

require 'runtime_command/builder'
require 'runtime_command/logger'

module RuntimeCommand
  def self.builder
    RuntimeCommand::Builder.new
  end
end

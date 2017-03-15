require 'spec_helper'

describe RuntimeCommand do
  it 'has a version number' do
    expect(RuntimeCommand::VERSION).not_to be nil
  end
end

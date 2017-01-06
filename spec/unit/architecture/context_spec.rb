require 'araignee/architecture/context'

include Araignee::Architecture

RSpec.describe Araignee::Architecture::Context do
  it 'config is accessible' do
    expect { Context.config = {} }.not_to raise_error
  end
end

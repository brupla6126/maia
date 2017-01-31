require 'araignee/architecture/context'

include Araignee::Architecture

RSpec.describe Context do
  it 'config is accessible' do
    expect { Context.config = {} }.not_to raise_error
  end
end

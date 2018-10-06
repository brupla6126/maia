require 'araignee/architecture/context'

RSpec.describe Architecture::Context do
  it 'config is accessible' do
    expect { Architecture::Context.config = {} }.not_to raise_error
  end
end

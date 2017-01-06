require 'araignee'

describe Araignee do
  it 'verify Araignee::VERSION is set' do
    expect(Araignee::VERSION).not_to be nil
  end
end

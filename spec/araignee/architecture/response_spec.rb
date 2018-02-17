require 'araignee/architecture/response'

RSpec.describe Architecture::Story::Response do
  subject { response }

  let(:response) { described_class.new(result: result, view_model: view_model) }

  let(:result) { double('[result]') }
  let(:view_model) { double('[view_model]') }

  it { expect(response.result).to eq(result) }
  it { expect(response.view_model).to eq(view_model) }
end

require 'araignee/stories/interactor'

RSpec.describe Araignee::Stories::Interactor do
  let(:interactor_config) { OpenStruct.new(a: 1, b: 2) }
  let(:interactor_context) { OpenStruct.new(presenters: {}) }
  let(:interactor) { described_class.new(context: interactor_context, config: interactor_config) }

  subject { interactor }

  describe '#initialize' do
    it 'initializes' do
      expect(subject.config).to eq(interactor_config)
      expect(subject.context).to eq(interactor_context)
    end
  end

  describe '#process' do
    subject { super().process(request) }

    let(:initial_response) { { status: :ok } }
    let(:request) { OpenStruct.new }

    it 'returns initial response' do
      expect(subject).to eq(initial_response)
    end
  end
end

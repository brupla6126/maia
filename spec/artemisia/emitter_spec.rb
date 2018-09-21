require 'artemisia/emitter'

RSpec.describe Artemisia::Emitter do
  class MyEmitter
    include Artemisia::Emitter

    def subscribed
      @subscriptions
    end
  end

  let(:emitter) { MyEmitter.new }

  subject { emitter }

  describe '#on' do
    subject { super().on(:create) {} }

    before { emitter.on(:moved) {} }

    it 'adds a subscription to an event type' do
      subject
      expect(emitter.subscribed.count).to eq(2)
      expect(emitter.subscribed[:create].count).to eq(1)
    end

    it 'returns itself' do
      expect(subject).to eq(emitter)
    end
  end

  describe '#emit' do
    let(:params) { { a: 1 } }

    before { emitter.on(:create) {} }
    before { emitter.on(:create) {} }
    before { emitter.on(:moved) {} }

    subject { super().emit(:create, params) }

    it 'subscribers gets notified' do
      expect(emitter.subscribed[:create][0]).to receive(:call)
      expect(emitter.subscribed[:create][1]).to receive(:call)
      expect(emitter.subscribed[:moved][0]).not_to receive(:call)
      subject
    end
  end
end

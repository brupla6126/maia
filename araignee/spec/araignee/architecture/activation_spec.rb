require 'araignee/architecture/activation'
require 'araignee/stories/entity'

RSpec.describe Araignee::Architecture::Activation do
  class MyEntity < Araignee::Stories::Entity
    include Araignee::Architecture::Activation
  end

  subject { entity }

  let(:attributes) { {} }
  let(:entity) { MyEntity.new(attributes: attributes) }

  describe '#initialize' do
    context 'with no parameters' do
      let(:params) { {} }

      it 'is not activated' do
        expect(subject.activated_at).to eq(nil)
      end

      it 'is not deactivated' do
        expect(subject.deactivated_at).to eq(nil)
      end
    end
  end

  describe '#activate' do
    subject { super().activate(time) }

    before  { subject }

    context 'with no time specified' do
      let(:time) { nil }

      it 'activated_at is valid' do
        expect(entity.activated_at).to be_a(Time)
        expect(entity.deactivated_at).to eq(nil)
      end
    end

    context 'with time specified' do
      let(:time) { Time.now }

      it 'activated_at is valid' do
        expect(entity.activated_at).to be_a(Time)
        expect(entity.activated_at).to eq(time)
        expect(entity.deactivated_at).to eq(nil)
      end
    end
  end

  describe '#deactivate' do
    subject { super().deactivate(time) }

    context 'was not activated' do
      before  { subject }

      context 'with time specified' do
        let(:time) { Time.now }

        it 'activated_at and deactivated_at are nil' do
          expect(entity.activated_at).to eq(nil)
          expect(entity.deactivated_at).to eq(nil)
        end
      end
    end

    context 'was already activated' do
      before { entity.activate(activation_time) }
      before { subject }

      let(:activation_time) { Time.now }

      context 'with no time specified' do
        let(:time) { nil }

        it 'deactivated_at is valid' do
          expect(entity.deactivated_at).to be_a(Time)
        end
      end

      context 'with time specified' do
        let(:time) { Time.now }

        it 'deactivated_at is valid' do
          expect(entity.activated_at).to eq(activation_time)
          expect(entity.deactivated_at).to be_a(Time)
        end
      end
    end
  end

  describe '#activated?' do
    subject { super().activated? }

    before { entity.activate(time) }

    context 'activated in the past' do
      let(:time) { Time.now - 60 }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'activated in the future' do
      let(:time) { Time.now + 60 }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end
end

require 'araignee/utils/recorder'

RSpec.describe Recorder do
  let(:attributes) { {} }
  let(:recorder) { described_class.new(attributes) }

  describe '#initialize' do
    subject { recorder }

    context 'attributes of wrong type' do
      let(:attributes) { [] }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'attributes configuring a serie' do
      let(:attributes) { { series: { duration: { max_count: 10 } } } }

      it 'should configure serie :duration' do
        expect(subject.data[:duration][:max_count]).to eq(10)
        expect(subject.data[:duration][:values]).to eq([])
      end

      context 'without specifying serie max_count' do
        let(:attributes) { { series: { duration: {} } } }

        it 'should set serie max_count to -1' do
          expect(subject.data[:duration][:max_count]).to eq(-1)
        end
      end
    end
  end

  describe '#record' do
    let(:serie) { :duration }
    let(:value) { 1.23 }

    subject { recorder.record(serie, value) }

    context 'serie not configured' do
      let(:attributes) { { series: {} } }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'recording a serie' do
      let(:max_count) { 10 }
      let(:attributes) { { series: { duration: { max_count: max_count } } } }

      before { subject }

      it 'should record serie data' do
        expect(recorder.data[:duration][:values]).to eq([value])
      end

      context 'hitting max_count' do
        before { 1.upto(20).each { recorder.record(serie, value) } }

        it 'should have kept 10 values' do
          expect(recorder.data[:duration][:values].count).to eq(max_count)
        end
      end
    end
  end

  describe '#min' do
    let(:serie) { :duration }
    let(:values) { [10, 2, 30] }

    context 'serie not configured' do
      let(:attributes) { { series: {} } }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'serie configured' do
      subject { recorder.min(serie) }

      let(:attributes) { { series: { duration: {} } } }

      before { values.each { |value| recorder.record(serie, value) } }

      it 'should return min value' do
        expect(subject).to eq(2)
      end
    end
  end

  describe '#max' do
    let(:serie) { :duration }
    let(:values) { [10, 2, 30] }

    context 'serie not configured' do
      let(:attributes) { { series: {} } }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'serie configured' do
      subject { recorder.max(serie) }

      let(:attributes) { { series: { duration: {} } } }

      before { values.each { |value| recorder.record(serie, value) } }

      it 'should return max value' do
        expect(subject).to eq(30)
      end
    end
  end

  describe '#avg' do
    let(:serie) { :duration }
    let(:values) { [10, 2, 30] }

    context 'serie not configured' do
      let(:attributes) { { series: {} } }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'serie configured' do
      subject { recorder.avg(serie) }

      let(:attributes) { { series: { duration: {} } } }

      before { values.each { |value| recorder.record(serie, value) } }

      it 'should return avg value' do
        expect(subject).to eq(14)
      end
    end
  end

  describe '#total' do
    let(:serie) { :duration }
    let(:values) { [10, 2, 30] }

    context 'serie not configured' do
      let(:attributes) { { series: {} } }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'serie configured' do
      subject { recorder.total(serie) }

      let(:attributes) { { series: { duration: {} } } }

      before { values.each { |value| recorder.record(serie, value) } }

      it 'should return total' do
        expect(subject).to eq(42)
      end
    end
  end
end

require 'araignee/utils/stats'

RSpec.describe Stats do
  class TestStats
    include Stats

    attr_reader :stats
  end

  subject { TestStats.new }

  describe 'initialize' do
    it 'should not have stats' do
      expect(subject.stats).to eq(nil)
    end
  end

  describe 'start_stats' do
    before { subject.start_stats }

    it 'should have start time' do
      expect(subject.stats[:start]).not_to eq(nil)
    end
  end

  describe 'finish_stats' do
    before do
      subject.start_stats
      subject.finish_stats
    end

    it 'should have start and finish time' do
      expect(subject.stats[:start]).not_to eq(nil)
      expect(subject.stats[:finish]).not_to eq(nil)
    end

    it 'should have duration calculated' do
      expect(subject.stats[:duration]).not_to eq(nil)
      expect(subject.stats[:duration]).to eq((subject.stats[:finish] - subject.stats[:start]).round(4))
    end
  end
end

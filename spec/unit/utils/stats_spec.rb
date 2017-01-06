require 'araignee/utils/stats'

include Araignee, Araignee::Utils

RSpec.describe Utils::Stats do
  class TestStats
    include Stats
    attr_reader :stats
  end

  describe 'initialize' do
    let(:test) { TestStats.new }

    it 'should not have stats' do
      expect(test.stats).to eq(nil)
    end
  end

  describe 'start_stats' do
    let(:test) { TestStats.new }
    before { test.start_stats }

    it 'should have start time' do
      expect(test.stats[:start]).not_to eq(nil)
    end
  end

  describe 'finish_stats' do
    let(:test) { TestStats.new }
    before do
      test.start_stats
      test.finish_stats
    end

    it 'should have start and finish time' do
      expect(test.stats[:start]).not_to eq(nil)
      expect(test.stats[:finish]).not_to eq(nil)
    end

    it 'should have duration calculated' do
      expect(test.stats[:duration]).not_to eq(nil)
      expect(test.stats[:duration]).to eq((test.stats[:finish] - test.stats[:start]).round(4))
    end
  end
end

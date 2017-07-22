# usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/timeout'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Timeout do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when timeout is not set' do
      it 'should raise ArgumentError timeout must be > 0' do
        expect { Araignee::AI::Behavior::Timeout.new }.to raise_error(ArgumentError, 'timeout must be > 0')
      end
    end
  end

  describe '#process' do
    context 'when timeout of 3 seconds' do
      let(:timeout) { Araignee::AI::Behavior::Timeout.new(timeout: 3) }
      before { timeout.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(timeout.process(entity, world).running?).to eq(true)
      end
    end
  end
end

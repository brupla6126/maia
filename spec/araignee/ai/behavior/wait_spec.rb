#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/wait'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Wait do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when wait is not set' do
      it 'should raise ArgumentError wait must be > 0' do
        expect { Wait.new }.to raise_error(ArgumentError, 'wait must be > 0')
      end
    end
  end

  describe '#process' do
    context 'when wait of 3 seconds' do
      let(:wait) { Wait.new(wait: 3) }
      before { wait.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(wait.process(entity, world).running?).to eq(true)
      end
    end
  end
end

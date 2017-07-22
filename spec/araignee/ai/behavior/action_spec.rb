#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/action'
require 'araignee/utils/log'

require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Action do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#process' do
    context 'when doing 5 loops of ActionSuccess but maximum equals to 3' do
      let(:entity) { { number: 0 } }
      let(:action) { ActionSuccess.new }
      before { action.start }

      it 'succeeded? should equal true' do
        response = nil
        1.upto 3 do
          response = action.process(entity, world).succeeded?
        end
        expect(response).to eq(true)
        expect(entity[:number]).to eq(3)
      end
    end
  end
end

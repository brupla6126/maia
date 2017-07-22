#!/usr/bin/env ruby
# encoding: utf-8
require 'timecop'
require 'araignee/ai/behavior/action'
require 'araignee/ai/behavior/expiration'

require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Expiration do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when expires is not set' do
      it 'should raise ArgumentError expires must be > 0' do
        expect { Expiration.new(node: ActionSuccess.new) }.to raise_error(ArgumentError, ':expires must be > 0')
      end
    end
  end

  describe '#process' do
    context 'when doing 3 loops of ActionSuccess and maximum equals to 3' do
      let(:entity) { { number: 0 } }

      it 'running? should equal true' do
        expiration = Expiration.new(node: ActionRunning.new, expires: 3)
        expiration.start

        response = nil
        1.upto 3 do
          response = expiration.process(entity, world).running?
          # Log.debug { "response: #{response}" }

          Timecop.travel Time.now + 1
        end

        expect(response).to eq(true)

        Timecop.return
      end
    end

    context 'when doing 5 loops of ActionSuccess but maximum equals to 3' do
      let(:entity) { { number: 0 } }

      it 'failed? should equal true' do
        expiration = Expiration.new(node: ActionRunning.new, expires: 3)
        expiration.start

        response = nil
        1.upto 5 do
          response = expiration.process(entity, world).failed?
          # Log.debug { "response: #{response}" }

          Timecop.travel Time.now + 1
        end

        expect(response).to eq(true)

        Timecop.return
      end
    end
  end
end

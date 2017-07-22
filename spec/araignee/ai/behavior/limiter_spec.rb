#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/limiter'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Limiter do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when node parameter is nil' do
      it 'should raise ArgumentError when node parameter is nil' do
        expect { Limiter.new }.to raise_error(ArgumentError)
      end
    end

    context 'when times parameter is not set' do
      let(:limiter) { Limiter.new(node: ActionSuccess.new) }
      before { limiter.start }

      it ':times should default to 1' do
        expect(limiter.times).to eq(1)
      end
    end

    context 'when times parameter is set to invalid value < 1' do
      it 'should raise ArgumentError, times must be > 0' do
        expect { Limiter.new(node: ActionSuccess.new, times: 0) }.to raise_error(ArgumentError, 'times must be > 0')
        expect { Limiter.new(node: ActionSuccess.new, times: -3) }.to raise_error(ArgumentError, 'times must be > 0')
      end
    end

    context 'when times parameter is set to 3' do
      let(:limiter) { Limiter.new(node: ActionSuccess.new, times: 3) }
      before { limiter.start }

      it ':times should equal 3' do
        expect(limiter.times).to eq(3)
      end
    end
  end

  describe '#process' do
    context 'when doing 5 loops of ActionSuccess and :times equals to 3' do
      entity = { number: 0 }

      it 'failed? should equal true' do
        limiter = Limiter.new(node: ActionRunning.new, times: 3)
        limiter.start

        response = nil
        1.upto 5 do
          response = limiter.process(entity, world).failed?
        end

        expect(response).to eq(true)
      end
    end

    context 'when doing 2 loops of ActionSuccess and :times equals to 3' do
      entity = { number: 0 }

      it 'succeeded? should equal true' do
        limiter = Limiter.new(node: ActionSuccess.new, times: 3)
        limiter.start

        response = nil
        1.upto 2 do
          response = limiter.process(entity, world).succeeded?
        end

        expect(response).to eq(true)
      end
    end
  end
end

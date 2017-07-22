#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/parallel'

require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Parallel do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when attributes :completion and failure are not set' do
      it ':completion and failure should default to 0' do
        parallel = Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new])
        expect(parallel.completion).to eq(0)
        expect(parallel.failure).to eq(0)
      end
    end

    context 'when completion is set' do
      it 'should raise ArgumentError, completion policy' do
        expect { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new], completion: :two) }.to raise_error(TypeError, 'completion must be Integer')
      end
      it 'should raise ArgumentError, completion policy' do
        expect { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new], completion: -2) }.to raise_error(ArgumentError, 'completion must be >= 0')
      end
    end

    context 'when failure is set' do
      it 'should raise ArgumentError, failure' do
        expect { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new], completion: 0, failure: :two) }.to raise_error(TypeError, 'failure must be Integer')
      end
      it 'should raise ArgumentError, failure' do
        expect { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new], completion: 0, failure: -3) }.to raise_error(ArgumentError, 'failure must be >= 0')
      end
    end

    context 'when completion and failure are equal' do
      it 'should raise ArgumentError, completion and failure must not equal' do
        expect { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new], completion: 1, failure: 1) }.to raise_error(ArgumentError, 'completion and failure must not equal')
      end
    end
  end

  describe '#process' do
    context 'when ActionSuccess, ActionFailure, ActionFailure and :completion, :failure are not set' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new, ActionCanceled.new]) }
      before { parallel.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).running?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionFailure and :completion => 1' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new], completion: Integer::MAX) }
      before { parallel.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).running?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionFailure and :completion => 2' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new], completion: 2) }
      before { parallel.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).running?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionFailure and :failure => Integer::MAX' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new], completion: 0, failure: Integer::MAX) }
      before { parallel.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).running?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure and :completion => Integer::MAX' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new], completion: Integer::MAX) }
      before { parallel.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).running?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionSuccess and :failure => 1' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionSuccess.new], completion: 0, failure: 1) }
      before { parallel.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).failed?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionFailure and :failure => 2' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new], completion: 0, failure: 2) }
      before { parallel.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).failed?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionFailure and :failure => Integer::MAX' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new], completion: 0, failure: Integer::MAX) }
      before { parallel.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).running?).to eq(true)
      end
    end

    context 'when ActionFailure, ActionFailure, ActionFailure and :failure => Integer::MAX' do
      let(:parallel) { Parallel.new(nodes: [ActionFailure.new, ActionFailure.new, ActionFailure.new], completion: 0, failure: Integer::MAX) }
      before { parallel.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).failed?).to eq(true)
      end
    end

    context 'when ActionSuccess, ActionFailure, ActionFailure, ActionFailure and :completion => 3, :failure => 2' do
      let(:parallel) { Parallel.new(nodes: [ActionSuccess.new, ActionFailure.new, ActionFailure.new, ActionFailure.new], completion: 3, failure: 2) }
      before { parallel.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).failed?).to eq(true)
      end
    end

    context 'when ActionFailure, ActionFailure, ActionFailure and :completion => 3' do
      let(:parallel) { Parallel.new(nodes: [ActionFailure.new, ActionFailure.new, ActionFailure.new], completion: 3, failure: Integer::MAX) }
      before { parallel.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(parallel.process(entity, world).failed?).to eq(true)
      end
    end
  end
end

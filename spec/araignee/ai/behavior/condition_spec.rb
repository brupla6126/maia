#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/behavior/action'
require 'araignee/ai/behavior/condition'

require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Condition do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when term is not set' do
      it 'should raise ArgumentError term is nil' do
        expect { Condition.new(no: ActionFailure.new) }.to raise_error(ArgumentError, 'term nil')
      end
    end

    context 'when yes is not set' do
      it 'should raise ArgumentError yes is nil' do
        expect { Condition.new(term: ActionFailure.new, no: ActionFailure.new) }.to raise_error(ArgumentError, 'yes nil')
      end
    end

    context 'when no is not set' do
      it 'should raise ArgumentError no is nil' do
        expect { Condition.new(term: ActionFailure.new, yes: ActionSuccess.new) }.to raise_error(ArgumentError, 'no nil')
      end
    end

    context 'when term is set' do
      let!(:term) { ActionFailure.new }
      let!(:yes) { ActionSuccess.new }
      let!(:no) { ActionFailure.new }
      let(:condition) { Condition.new(term: term, yes: yes, no: no) }

      it 'condition term should equal term' do
        expect(condition.term).to eq(term)
      end
      it 'condition yes should equal yes' do
        expect(condition.yes).to eq(yes)
      end
      it 'condition no should equal no' do
        expect(condition.no).to eq(no)
      end
    end
  end

  describe '#process' do
    context 'when term resolve to true' do
      let(:condition) { Condition.new(term: ActionSuccess.new, yes: ActionSuccess.new, no: ActionFailure.new) }
      before { condition.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(condition.process(entity, world).succeeded?).to eq(true)
      end
    end

    context 'when term resolve to false' do
      let(:condition) { Condition.new(term: ActionFailure.new, yes: ActionSuccess.new, no: ActionFailure.new) }
      before { condition.start }

      it 'succeeded should equal false' do
        entity = { number: 0 }
        expect(condition.process(entity, world).succeeded?).to eq(false)
      end
    end
  end
end

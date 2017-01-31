require 'araignee/architecture/presenter'

include Araignee::Architecture

class MyPresenter < Presenter
  attr_reader :entity
end

RSpec.describe Presenter do
  describe '#initialize' do
    context 'when entity is nil' do
      it 'should raise ArgumentError' do
        expect { Presenter.new(nil) }.to raise_error(ArgumentError)
      end
    end
    context 'when entity is valid' do
      let(:entity) { 'entity' }
      let(:presenter) { MyPresenter.new(entity) }

      it 'should set entity attribute' do
        expect(presenter.entity).to eq('entity')
      end
    end
  end
end

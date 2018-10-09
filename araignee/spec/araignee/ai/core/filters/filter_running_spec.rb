require 'araignee/ai/core/node'
require 'araignee/ai/core/filters/filter_running'

RSpec.describe Ai::Core::Filters::FilterRunning do
  let(:node1) { Ai::Core::Node.new }
  let(:node2) { Ai::Core::Node.new }
  let(:node3) { Ai::Core::Node.new }
  let(:nodes) { [node1, node2] }
  let(:filter) { described_class.new }

  subject { filter }

  describe 'accept' do
    subject { super().accept(nodes) }

    before { node1.start! }
    before { node2.start! }
    before { node2.stop! }
    before { node3.start! }
    before { node3.pause! }

    it 'returns running nodes only' do
      expect(subject).to eq([node1])
    end
  end
end

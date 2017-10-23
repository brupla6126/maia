require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/filters/filter_running'

RSpec.describe Ai::Core::Filters::FilterRunning do
  let(:node1) { Fabricate(:ai_node) }
  let(:node2) { Fabricate(:ai_node) }
  let(:node3) { Fabricate(:ai_node) }
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

require 'araignee/ai/core/fabricators/ai_balancer_fabricator'

RSpec.describe 'AI BalancerFabricator' do
  let(:balancer) { Fabricate(:ai_balancer) }

  subject { balancer }

  describe '#initialize' do
    it 'has no children' do
      expect(subject.children.empty?).to eq(true)
    end
  end
end

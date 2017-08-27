# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # For picking a single node
    module Picking
      module PickProbability
        def pick_node(nodes)
          return nil if nodes.empty?

          total_weight = nodes.map(&:probability).inject(:+)

          ranges = {}
          start = 1.0
          finish = 0.0

          nodes.sort_by(&:probability).each do |node|
            finish = (start + node.probability)

            ranges[(start..finish - 1.0)] = node

            start = finish
          end

          lucky_number = 1.0 + Random.rand(total_weight - 1.0)

          winner = ranges.keys.select { |range| range.include?(lucky_number) }.first

          ranges[winner]
        end
      end
    end
  end
end

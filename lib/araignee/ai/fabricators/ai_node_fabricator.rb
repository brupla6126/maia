require 'fabrication'

require 'araignee/ai/node'
require 'araignee/utils/recorder'

Fabricator(:ai_node, from: 'AI::Node') do
end

Fabricator(:ai_node_recorded, from: :ai_node) do
  recorder { Recorder.new(series: { duration: {} }) }
end

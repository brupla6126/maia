require 'fabrication'

require 'araignee/ai/core/node'
require 'araignee/utils/recorder'

Fabricator(:ai_node, from: 'Ai::Core::Node') do
end

Fabricator(:ai_node_recorded, from: :ai_node) do
  recorder { Recorder.new(series: { duration: {} }) }
end

# by resppnse
Fabricator(:ai_node_succeeded, from: 'Ai::Core::Node') do
  response :succeeded
end

Fabricator(:ai_node_busy, from: 'Ai::Core::Node') do
  response :busy
end

Fabricator(:ai_node_failed, from: 'Ai::Core::Node') do
  response :failed
end

# by state
Fabricator(:ai_node_running, from: 'Ai::Core::Node') do
  state :running
end

Fabricator(:ai_node_stopped, from: 'Ai::Core::Node') do
  state :stopped
end

Fabricator(:ai_node_paused, from: 'Ai::Core::Node') do
  state :paused
end

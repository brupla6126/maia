require 'fabrication'
require 'araignee/ai/core/interrogator'
require 'araignee/ai/core/fabricators/ai_node_fabricator'

Fabricator(:ai_interrogator, from: 'Ai::Core::Interrogator') do
end

Fabricator(:ai_interrogator_busy, from: 'Ai::Core::Interrogator') do
  child { Fabricate(:ai_node_busy) }
end

Fabricator(:ai_interrogator_failed, from: 'Ai::Core::Interrogator') do
  child { Fabricate(:ai_node_failed) }
end

Fabricator(:ai_interrogator_succeeded, from: 'Ai::Core::Interrogator') do
  child { Fabricate(:ai_node_succeeded) }
end

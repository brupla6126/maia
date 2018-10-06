require 'fabrication'
require 'araignee/ai/core/repeater'
require 'araignee/ai/core/repeater_until_failure'
require 'araignee/ai/core/repeater_until_success'
require 'araignee/ai/core/repeater_number_times'

Fabricator(:ai_repeater, from: 'Ai::Core::Repeater') do
end
Fabricator(:ai_repeater_until_success, from: 'Ai::Core::RepeaterUntilSuccess') do
end
Fabricator(:ai_repeater_until_failure, from: 'Ai::Core::RepeaterUntilFailure') do
end

Fabricator(:ai_repeater_number_times, from: 'Ai::Core::RepeaterNumberTimes') do
end

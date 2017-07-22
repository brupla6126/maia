#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/behavior/repeater'
require 'araignee/ai/behavior/process/process_until_failure'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      class RepeaterUntilFailure < Repeater
        include ProcessChildUntilFailure
      end
    end
  end
end

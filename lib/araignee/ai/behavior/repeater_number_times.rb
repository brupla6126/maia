#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/behavior/repeater'
require 'araignee/ai/behavior/process/process_number_times'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      class RepeaterNumberTimes < Repeater
        include ProcessChildNumberTimes
      end
    end
  end
end

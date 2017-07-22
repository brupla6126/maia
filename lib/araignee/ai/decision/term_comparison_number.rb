#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'term_comparison'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Decision Tree classes
    module Decision
      # Class for comparing numbers
      class TermComparisonNumber < TermComparison
        attribute :number, Integer

        def initialize(attributes = {})
          super

          self
        end

        def truth?(entity, world)
          n = get_comparison_number(entity, world)

          truth =
            case comparison
            when '==' then compare_equal n
            when '<>' then !compare_equal n
            when '<' then compare_lower n
            when '<=' then compare_lower_equal n
            when '>' then compare_greater n
            when '>=' then compare_greater_equal n
            else raise Exception, "comparison not supported: #{comparison}"
            end

          truth
        end

        def compare_equal(n)
          n == number
        end

        def compare_lower(n)
          n < number
        end

        def compare_lower_equal(n)
          n <= number
        end

        def compare_greater(n)
          n > number
        end

        def compare_greater_equal(n)
          n >= number
        end

        protected

        def get_comparison_number(entity)
        end

        def validate_attributes
          super

          # raise TypeError, 'comparison must be String' unless comparison.is_a?(String)
        end
      end
    end
  end
end

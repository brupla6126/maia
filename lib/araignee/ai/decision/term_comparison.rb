#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'term'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Decision Tree classes
    module Decision
      # class TermComparison
      class TermComparison < Term
        attribute :comparison, String, default: nil

        def initialize(attributes = {})
          super

          self
        end

        protected

        def validate_attributes
          super

          # raise TypeError, 'comparison must be String' unless comparison.is_a?(String)
        end
      end
    end
  end
end

#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'term_comparison'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Decision Tree classes
    module Decision
      # Class TermNot, logical NOT
      class TermEmpty < TermComparison
        def initialize(comparison)
          super
        end

        protected

        def get_comparison_text(entity)
          entity['estado']
        end
      end
    end
  end
end

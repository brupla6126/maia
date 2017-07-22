#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'term_comparison'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Decision Tree classes
    module Decision
      # Class
      class TermComparisonText < TermComparison
        attribute :text, String, default: ''
        attribute :ignore_case, String, default: false

        def initialize(attributes = {})
          super
        end

        def truth?(entity, world)
          s = get_comparison_text(entity, world)

          # Log[self.class].debug {"s: #{s}, text: #{text}"}
          # Log[self.class].debug {"comparison: #{@comparison}"}

          truth =
            case comparison
            when '==' then compare_equal s
            when '<>' then !compare_equal s
            when '<' then compare_lower s
            # when '<=' then compare_lowerOIgual s
            when '>' then compare_greater s
            # when '>=' then compare_greaterOIgual s
            when '~' then compare_part s
            when '{' then compare_start s
            when '}' then compare_end s
            else raise Exception, "Operacion no soportada: #{comparison}"
            end
          # Log[self.class].debug {"truth: #{truth}"}

          truth
        end

        protected

        def compare_equal(s)
          return true if s.nil? && text.nil?
          return false if s.nil? && !text.nil?
          (ignore_case ? s.casecmp(text) : s == text)
        end

        def compare_lower(s)
          return false if s.nil? || text.nil?
          (ignore_case ? s.casecmp(text) : (s <=> text) == -1)
        end

        def compare_greater(s)
          return false if s.nil? || text.nil?
          (ignore_case ? s.casecmp(text) : (s <=> text) == 1)
        end

        def compare_part(s)
          return false if s.nil? || text.nil?
          return s.include?(text) if !s.nil? && !text.nil?
          false
        end

        def compare_start(s)
          return false if s.nil? || text.nil?
          return s.start_with?(text) if !s.nil? && !text.nil?
          false
        end

        def compare_end(s)
          return false if s.nil? || text.nil?
          return s.end_with?(text) if !s.nil? && !text.nil?
          false
        end

        def get_comparison_text(entity)
        end

        def validate_attributes
          super

          # raise TypeError, 'terms must be Array' unless terms.is_a?(Array)
          # raise TypeError, 'terms empty' if terms.empty?
        end
      end
    end
  end
end

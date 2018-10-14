module Araignee
  module Utils
    # To record data
    class Recorder
      attr_reader :data

      def initialize(attributes)
        raise ArgumentError, 'attributes must be Hash' unless attributes.instance_of?(Hash)

        @data = {}

        return unless attributes[:series]

        attributes[:series].each do |serie, options|
          prepare(serie, options)
        end
      end

      def record(serie, value)
        raise ArgumentError, "serie #{serie} not configured" unless @data[serie]

        unless @data[serie][:max_count] == -1
          @data[serie][:values].delete_at(0) if @data[serie][:values].count >= @data[serie][:max_count]
        end

        @data[serie][:values].push(value)
      end

      def min(serie)
        raise ArgumentError, "serie #{serie} not configured" unless @data[serie]

        @data[serie][:values].min
      end

      def max(serie)
        raise ArgumentError, "serie #{serie} not configured" unless @data[serie]

        @data[serie][:values].max
      end

      def total(serie)
        raise ArgumentError, "serie #{serie} not configured" unless @data[serie]

        @data[serie][:values].sum
      end

      def avg(serie)
        raise ArgumentError, "serie #{serie} not configured" unless @data[serie]

        @data[serie][:values].inject(0.0) { |sum, el| sum + el } / @data[serie][:values].size
      end

      private

      def prepare(serie, options = {})
        @data[serie] = { values: [], max_count: -1 }.merge(options)
      end
    end
  end
end

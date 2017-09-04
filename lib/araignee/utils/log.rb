require 'logger'

# Log class for logging purposes
class Log
  # static methods
  class << self
    def debug
      self[:default].debug yield
    end

    def info
      self[:default].info yield
    end

    def warn
      self[:default].warn yield
    end

    def error
      self[:default].error yield
    end

    def fatal
      self[:default].fatal yield
    end

    def loggers
      @loggers ||= {}
    end

    def []=(id, logger)
      raise ArgumentError, 'id nil' unless id
      raise ArgumentError, 'logger nil' unless logger

      loggers[id] = logger
    end

    def [](id)
      raise ArgumentError, 'id nil' unless id

      loggers[id] || loggers[:default] || Logger.new('/dev/null')
    end

    def close
      # loggers.values.map(&:close)
      loggers.clear
    end
  end
end

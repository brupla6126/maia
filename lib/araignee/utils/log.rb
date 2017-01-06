require 'logger'

module Araignee
  module Utils
    #  config = {
    #    logging: {
    #      loggers: {
    #        console: Logger.new(STDOUT),
    #        file: Logger.new('log/agriculture.log', 'daily')
    #      },
    #      formatters: {
    #        simple: proc do |severity, _datetime, _progname, msg|
    #                  "#{severity.rjust(5)} | #{msg}\n"
    #                end,
    #        date_time: proc do |severity, datetime, _progname, msg|
    #                     date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
    #                     "#{date_format} #{severity.rjust(5)} | #{msg}\n"
    #                   end,
    #        date_time_ms: proc do |severity, datetime, _progname, msg|
    #                        date_format = datetime.strftime('%Y-%m-%d %H:%M:%S.%L')
    #                        "#{date_format} #{severity.rjust(5)} | #{msg}\n"
    #                      end,
    #        time_ms: proc do |severity, datetime, _progname, msg|
    #                   date_format = datetime.strftime('%H:%M:%S.%L')
    #                   "#{date_format} #{severity.rjust(5)} | #{msg}\n"
    #                 end
    #      },
    #    logs: {}
    #  }
    # }

    # config[:logging][:logs][:default] = {
    #   logger: :console,
    #   level: Logger::DEBUG,
    #   formatter: :simple
    # }

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

          loggers[id] ||= logger
        end

        def [](id)
          raise ArgumentError, 'id nil' unless id

          loggers[id] || loggers[:default] || Logger.new('/dev/null')
        end

        def configure(config)
          config[:logging][:logs].each do |id, params|
            logger = params[:logger]
            if params[:logger].is_a? Symbol
              logger = config[:logging][:loggers][params[:logger]]
            end

            logger.level = params[:level] || Logger::DEBUG
            logger.formatter = config[:logging][:formatters][params[:formatter]]

            Log[id] = logger # save logger in @@loggers
          end
        end

        def close
          # loggers.values.map(&:close)
          loggers.clear
        end
      end
    end
  end
end

Context.config = {
  logging: {
    loggers: {
      console: Logger.new(STDOUT)
    },
    formatters: {
      simple: proc do |severity, _datetime, _progname, msg|
                "#{severity.rjust(5)} | #{msg}\n"
              end,
      date_time: proc do |severity, datetime, _progname, msg|
                   date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
                   "#{date_format} #{severity.rjust(5)} | #{msg}\n"
                 end,
      date_time_ms: proc do |severity, datetime, _progname, msg|
                      date_format = datetime.strftime('%Y-%m-%d %H:%M:%S.%L')
                      "#{date_format} #{severity.rjust(5)} | #{msg}\n"
                    end
    },
    logs: {}
  }
}

Context.config[:logging][:logs][Log] = {
  logger: Logger.new(STDOUT),
  level: Logger::DEBUG,
  formatter: :simple
}
Context.config[:mongo] = {
  cienpie: {
    host: ['127.0.0.1:27017'],
    options: {
      # :user => '',
      # :password => '',
      connect: :direct, # replica_set, sharded
      # replica_set: '', # nombre de la replica
      # read: :secondary, # replicaset
      database: 'cienpie',
      min_pool_size: 1,
      max_pool_size: 5,
      wait_queue_timeout: 5
    },
    collections: {
      resources: {
        objectid: false
      },
      tests: {
        objectid: true
      }
    }
  }
}
Context.config[:redis] = {
  cienpie: {
    sentinels: [],
    host: '127.0.0.1',
    port: 6379,
    username: '',
    password: '',
    db: 0, # testing(0), servicios(1), cienpie(2), pulpo(3), web(6), robot(7)
  }
}
Context.config[:memcache] = {
  cienpie: {
    servers: ['127.0.0.1:11211'],
    options: {
      namespace: 'cienpie',
      compress: true,
      # username: '',
      # password: '',
    }
  }
}
Context.config[:mysql] = {
=begin
  cienpie: {
    servers: ['127.0.0.1:11211'],
    options: {
      namespace: 'cienpie',
      compress: true,
#      username: '',
#      password: ''
    }
  }
=end
}

require 'araignee/utils/log'

# class for implementing plugins
class Plugin
  attr_reader :contracts, :adapters, :name

  def self.contract(type)
    case type
    when :crud then [:exists?, :one, :all, :create, :update, :delete].freeze
    when :plugin then [:configure].freeze
    else []
    end
  end

  def initialize(contracts = [], adapters = [])
    raise ArgumentError, 'contracts must be set' unless contracts
    raise TypeError, 'contracts must be Array' unless contracts.is_a? Array
    raise ArgumentError, 'adapters must be set' unless adapters
    raise TypeError, 'adapters must be Array' unless adapters.is_a? Array

    @contracts = ([:plugin] + contracts).uniq
    @adapters = adapters
    @config = {}

    @name = self.class.name.gsub(/^.*::/, '').downcase.to_sym # downcase temp, put underscore. when String::underscore in helpers.rb tested
  end

  def configure(config)
    Log[@name].info { "#{@name}::configure()" }

    @config = config

    @adapters.each { |adapter| adapter.configure(config) if adapter.respond_to?(:configure) }
  end

  # will ask its descendant classes or adapter it they respond to all the contract's methods
  def honor_contract?(contract)
    honored = 0

    contract.each do |method|
      responded = respond_to? method

      unless responded
        responded = @adapters.select { |adapter| adapter.respond_to?(method) }.any?
      end

      honored += 1 if responded
    end

    honored == contract.length
  end
end

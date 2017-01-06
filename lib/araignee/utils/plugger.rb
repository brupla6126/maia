require_relative 'plugin'

module Araignee
  module Utils
    class PluginContractError < StandardError
    end

    # class for registering plugins
    class Plugger
      def self.plugins
        @plugins ||= {}
      end

      def self.contracts
        @contracts ||= {}
      end

      def self.reset
        @plugins = {}
        @contracts = {}
      end

      def self.add_contract(name, methods)
        # TODO: verify contract not already set
        contracts[name] = methods unless contracts.key?(name)
      end

      def self.register(plugin)
        return if plugins.key?(plugin.name)

        add_contract(:plugin, Plugin.contract(:plugin))
        add_contract(:crud, Plugin.contract(:crud))

        raise PluginContractError, 'Plugin does not have contracts' if plugin.contracts.empty?

        plugin.contracts.each do |name|
          raise PluginContractError, "Plugin referring to unregistered contract :#{name}" unless contracts[name]

          raise PluginContractError, "Plugin or its adapters do not honor contract :#{name}" unless plugin.honor_contract?(contracts[name])
        end

        plugins[plugin.name] = plugin
      end

      def self.unregister(plugin)
        plugins.delete plugin.name
      end

      def self.honoring(name, contract)
        return [] unless plugins[name]

        extensions = plugins.select do |_n, plugin|
          plugin.class.superclass == plugins[name].class && plugin.honor_contract?(contract)
        end

        extensions.values
      end

      def self.[](name)
        plugins[name]
      end
    end
  end
end

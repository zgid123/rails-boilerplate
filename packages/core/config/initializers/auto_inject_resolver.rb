# frozen_string_literal: true

require 'dry-auto_inject'

# fix problem of auto_inject with rails
# ref: https://github.com/dry-rb/dry-rails/issues/53#issuecomment-1127676389

module Dry
  module AutoInject
    class Strategies
      class Resolve < Module
        InstanceMethods = Class.new(Module)

        attr_reader :container, :dependency_map, :instance_mod

        def initialize(container, *dependency_names)
          super()
          @container = container
          @dependency_map = DependencyMap.new(*dependency_names)
          @instance_mod = InstanceMethods.new
        end

        # @api private
        def included(klass)
          define_resolvers
          klass.send(:include, instance_mod)
          super
        end

        private

        def define_resolvers
          instance_mod.class_exec(container, dependency_map) do |container, dependency_map|
            dependency_map.to_h.each do |name, key|
              define_method name do
                container[key]
              end
            end
          end
        end
      end

      register :resolve, Resolve
    end
  end
end

# frozen_string_literal: true

module Core
  module Render
    extend ActiveSupport::Concern

    def render_resource(resource, opts = {})
      resource_serializer_class, is_array = serializer_class(resource, opts)

      return resource if resource_serializer_class.nil?

      serializer_class_opt = if is_array
                               {
                                 each_serializer: resource_serializer_class
                               }
                             else
                               {
                                 serializer: resource_serializer_class
                               }
                             end

      render(
        json: resource_serializer_class.render(
          resource,
          opts.except(:each_serializer, :serializer)
          .merge(
            **serializer_class_opt,
            root: opts[:root].presence || :data
          )
        )
      )
    end

    private

    def serializer_class(resource, opts)
      return [] if resource.blank?

      is_array = resource.is_a?(Array)

      class_name = if is_array
                     opts[:each_serializer].presence || array_serializer_class(resource, opts)
                   else
                     opts[:serializer].presence || single_serializer_class(resource, opts)
                   end

      [class_name, is_array]
    rescue StandardError
      []
    end

    def single_serializer_class(resource, opts)
      "#{handle_namespace(resource.class, opts)}Serializer".constantize
    end

    def array_serializer_class(resource, opts)
      resource_class = if resource.respond_to?(:klass)
                         resource.klass
                       else
                         resource.first.class
                       end

      "#{handle_namespace(resource_class, opts)}Serializer".constantize
    end

    def handle_namespace(resource_class, opts)
      module_names = if opts[:module].present?
                       (opts[:module].is_a?(Array) ? opts[:module] : [opts[:module]]).map do |module_name|
                         module_name.to_s.capitalize
                       end
                     else
                       []
                     end.join('::')

      return if opts[:keep_namespace].present?

      if module_names.present?
        [module_names, resource_class].join('::')
      else
        resource_class.demodulize
      end
    end
  end
end

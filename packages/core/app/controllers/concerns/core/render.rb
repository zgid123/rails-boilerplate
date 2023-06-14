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
                     opts[:each_serializer].presence || "#{resource.klass}Serializer".constantize
                   else
                     opts[:serializer].presence || "#{resource.class}Serializer".constantize
                   end

      [class_name, is_array]
    rescue StandardError
      []
    end
  end
end

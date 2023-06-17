# frozen_string_literal: true

module CodeTemplate
  def engine_code
    @engine_code ||= "
      delegate :vite_ruby, to: :class

      class << self
        def vite_ruby
          @vite_ruby ||= ::ViteRuby.new(root:)
        end
      end

      config.app_middleware.use(
        Rack::Static,
        urls: [\"/\#{vite_ruby.config.public_output_dir}\"],
        root: root.join(vite_ruby.config.public_dir)
      )

      initializer 'vite_rails_engine.proxy' do |app|
        app.middleware.insert_before(0, ::ViteRuby::DevServerProxy, ssl_verify_none: true, vite_ruby:) if vite_ruby.run_proxy?
      end

      initializer 'vite_rails_engine.logger' do
        config.after_initialize do
          vite_ruby.logger = Rails.logger
        end
      end
    "
  end

  def vite_manifest(camelized_package_name)
    "
      def vite_manifest
        #{camelized_package_name}::Engine.vite_ruby.manifest
      end
    "
  end

  def layout_code
    "
      <%= vite_client_tag %>
      <%= vite_stylesheet_tag 'styles.scss' %>
      <%= vite_typescript_tag 'application', media: 'all' %>
    "
  end

  def require_vite_rails
    "require 'vite_rails'"
  end
end

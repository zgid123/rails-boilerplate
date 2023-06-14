# frozen_string_literal: true

require 'dry-auto_inject'
require 'dry-container'

module Core
  class InversionContainer
    extend ::Dry::Container::Mixin
  end
end

Core::Inject = Dry::AutoInject(Core::InversionContainer)

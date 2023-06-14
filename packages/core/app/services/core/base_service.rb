# frozen_string_literal: true

module Core
  class BaseService
    class << self
      def call(*args)
        new.call(*args)
      end
    end

    def call(*)
      raise NotImplementedError, "Must implement method call for #{self.class.name}."
    end
  end
end

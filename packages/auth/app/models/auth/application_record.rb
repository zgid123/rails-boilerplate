# frozen_string_literal: true

module Auth
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    class << self
      def inherited(subclass)
        subclass.table_name = subclass.name.gsub('Auth::', '').underscore.pluralize

        super
      end
    end
  end
end

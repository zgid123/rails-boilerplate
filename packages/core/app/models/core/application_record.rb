# frozen_string_literal: true

module Core
  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class
  end
end

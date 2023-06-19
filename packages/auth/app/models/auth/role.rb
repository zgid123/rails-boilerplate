# frozen_string_literal: true

module Auth
  class Role < ApplicationRecord
    has_and_belongs_to_many :users, class_name: 'Auth::User', join_table: :users_roles

    belongs_to :resource,
               polymorphic: true,
               optional: true

    validates :resource_type,
              inclusion: { in: Rolify.resource_types },
              allow_nil: true

    scopify
  end
end

# frozen_string_literal: true

module Auth
  class User < ApplicationRecord
    include Devise::JWT::RevocationStrategies::Allowlist

    rolify role_cname: 'Auth::Role', role_table_name: Auth::Role.table_name

    devise(
      :database_authenticatable,
      :registerable,
      :recoverable,
      :rememberable,
      #  :confirmable,
      #  :lockable,
      #  :timeoutable,
      #  :trackable,
      #  :omniauthable
      :validatable,
      :jwt_authenticatable,
      jwt_revocation_strategy: self
    )
  end
end

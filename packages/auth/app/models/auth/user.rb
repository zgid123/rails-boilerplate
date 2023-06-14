# frozen_string_literal: true

module Auth
  class User < ApplicationRecord
    include Devise::JWT::RevocationStrategies::Allowlist

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

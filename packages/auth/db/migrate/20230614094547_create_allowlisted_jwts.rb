# frozen_string_literal: true

class CreateAllowlistedJwts < ActiveRecord::Migration[7.0]
  def change
    create_table :allowlisted_jwts do |t|
      t.string :jti, null: false
      t.string :aud
      t.datetime :exp, null: false

      t.timestamps

      t.references :user, foreign_key: { on_delete: :cascade }, null: false
    end

    add_index :allowlisted_jwts, :jti, unique: true
  end
end

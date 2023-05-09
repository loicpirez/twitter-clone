# frozen_string_literal: true

# Create user table in db
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps # creates two columns: created_at and updated_at
    end
  end
end

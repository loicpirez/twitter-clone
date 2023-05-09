# frozen_string_literal: true

# Index users by emails
class AddIndexToUsersEmails < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
  end
end

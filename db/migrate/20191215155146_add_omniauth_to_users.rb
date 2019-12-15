class AddOmniauthToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :github_uid, :string
    add_column :users, :github_token, :string
    add_column :users, :google_uid, :string
    add_column :users, :google_token, :string
  end
end

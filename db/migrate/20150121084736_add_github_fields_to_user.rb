class AddGithubFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :g_uid, :integer
    add_column :users, :github, :string
    add_column :users, :g_login, :string
    add_column :users, :g_token, :string
    add_column :users, :repos_url, :string
    add_column :users, :g_commits, :integer

    add_index :users, :g_uid,                unique: true
    add_index :users, :g_login,              unique: true
    add_index :users, :g_token
    add_index :users, :repos_url
    add_index :users, :g_commits
  end
end

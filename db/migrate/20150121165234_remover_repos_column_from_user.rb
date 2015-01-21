class RemoverReposColumnFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :repos_url
  end
end

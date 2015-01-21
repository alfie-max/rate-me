class AddStackexchangeFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :s_uid, :integer
    add_column :users, :stackoverflow, :string
    add_column :users, :s_reputation, :integer
    add_column :users, :s_token, :string
  end
end

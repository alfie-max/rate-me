class AddDesignationToUser < ActiveRecord::Migration
  def change
    add_column :users, :designation, :string
  end
end

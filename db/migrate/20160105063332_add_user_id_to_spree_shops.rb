class AddUserIdToSpreeShops < ActiveRecord::Migration
  def change
    add_column :spree_shops, :user_id, :integer
    add_index :spree_shops, :user_id
  end
end

class BranchTableShopIdColNameChg < ActiveRecord::Migration
  def change 
     rename_column :spree_branches, :spree_shop_id, :shop_id
  end
end

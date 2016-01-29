class ProductTableShopIdColNameChg < ActiveRecord::Migration
  def change
    rename_column :spree_products, :spree_shop_id, :shop_id
  end
end

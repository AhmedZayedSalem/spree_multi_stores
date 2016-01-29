class JoinTableProductShopColnameChg < ActiveRecord::Migration
  def change
    rename_column :spree_product_shops, :spree_product_id, :product_id
    rename_column :spree_product_shops, :spree_shop_id, :shop_id
  end
end

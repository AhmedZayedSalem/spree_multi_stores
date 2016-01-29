class AddSpreeShopRefToSpreeProducts < ActiveRecord::Migration
  def change
    add_reference :spree_products, :spree_shop, index: true, foreign_key: true
  end
end

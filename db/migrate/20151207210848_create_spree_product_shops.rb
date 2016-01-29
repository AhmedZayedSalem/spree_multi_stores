class CreateSpreeProductShops < ActiveRecord::Migration
  def change
    create_table :spree_product_shops do |t|
      t.belongs_to :spree_product, index: true, foreign_key: true
      t.belongs_to :spree_shop, index: true, foreign_key: true
      t.integer :all_branches, default: 2

      t.timestamps null: false
    end
  end
end

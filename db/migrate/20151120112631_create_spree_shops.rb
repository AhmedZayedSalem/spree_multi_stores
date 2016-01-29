class CreateSpreeShops < ActiveRecord::Migration
  def change
    create_table :spree_shops do |t|
      t.string :name
      t.text :description
      t.datetime :available_on
      t.datetime :deleted_at
      t.string :permalink
      t.string :meta_description
      t.string :meta_keywords

      t.timestamps null: false
    end
  end
end

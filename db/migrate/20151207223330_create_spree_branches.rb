class CreateSpreeBranches < ActiveRecord::Migration
  def change
    create_table :spree_branches do |t|
      t.belongs_to :spree_shop, index: true, foreign_key: true
      t.string :address
      t.string :phone_number
      t.string :opening_hours
    end
  end
end

class CreateSpreeBranchProducts < ActiveRecord::Migration
  def change
    create_table :spree_branch_products do |t|
      t.belongs_to :spree_product, index: true, foreign_key: true
      t.belongs_to :spree_branch, index: true, foreign_key: true
    end
  end
end

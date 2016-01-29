class JoinTableBranchProductColnameChg < ActiveRecord::Migration
  def change
    rename_column :spree_branch_products, :spree_branch_id, :branch_id
    rename_column :spree_branch_products, :spree_product_id, :product_id

  end
end

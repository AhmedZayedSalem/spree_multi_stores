class AddAllBranchesToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :all_branches, :integer, default: 2
  end
end

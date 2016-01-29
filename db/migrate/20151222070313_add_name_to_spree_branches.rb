class AddNameToSpreeBranches < ActiveRecord::Migration
  def change
    add_column :spree_branches, :name, :string
  end
end

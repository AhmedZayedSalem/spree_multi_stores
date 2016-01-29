class AddDeletedAtToSpreeBranches < ActiveRecord::Migration
  def change
    add_column :spree_branches, :deleted_at, :datetime
  end
end

class RenamePermalinkToSlugForShops < ActiveRecord::Migration
  def change
    rename_column :spree_shops, :permalink, :slug
  end
end

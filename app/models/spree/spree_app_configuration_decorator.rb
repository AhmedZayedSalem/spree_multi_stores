module Spree
  AppConfiguration.class_eval do
    preference :admin_shops_per_page, :integer, default: 10
    preference :shops_per_page, :integer, default: 15
  end
end

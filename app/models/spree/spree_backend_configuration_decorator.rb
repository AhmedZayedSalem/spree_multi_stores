module Spree
  BackendConfiguration.class_eval do
    SHOP_TABS     ||= [:shops, :branches, :branch_products]
  end
end

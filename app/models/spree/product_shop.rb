module Spree
  class ProductShop < Spree::Base
    belongs_to :product
    belongs_to :shop
  end
end

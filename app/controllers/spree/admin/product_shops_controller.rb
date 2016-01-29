module Spree
  module Admin
    class ProductShopsController < ResourceController
      belongs_to 'spree/shop', :find_by => :slug
      before_action :find_products
      before_action :setup_product, only: :index

      private
        def find_products          
          @products = @shop.product_shops.products
        end

        def setup_product
          @shop.product_shops.build
        end
    end
  end
end

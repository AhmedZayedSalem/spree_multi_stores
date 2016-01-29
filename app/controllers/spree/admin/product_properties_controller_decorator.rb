module Spree
  module Admin
    ProductPropertiesController.class_eval do
       before_action :load_shop
       private
         def load_shop
           @shop = Shop.friendly.find(@product.shop_id)  
         end
    end
  end
end

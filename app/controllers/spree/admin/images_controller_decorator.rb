module Spree
  module Admin
    ImagesController.class_eval do
       before_action :load_shop
       private
         def load_shop
           @shop = Shop.friendly.find(@product.shop_id)  
         end
         def location_after_destroy
           spree.admin_shop_product_images_url(@shop, @product)
         end

         def location_after_save
           spree.admin_shop_product_images_url(@shop, @product)
         end
    end
  end
end

module Spree
  module Admin
    ImagesController.class_eval do
       before_action :load_shop
       private
         def load_shop
           if params[:shop_id] !=nil
             @shop = Shop.friendly.find(@product.shop_id)  
           end
         end
         def location_after_destroy
           if params[:shop_id] !=nil
             spree.admin_shop_product_images_url(@shop, @product)
           else
             spree.admin_product_images_url(@product)
           end
         end

         def location_after_save
           if params[:shop_id] !=nil
             spree.admin_shop_product_images_url(@shop, @product)
           else
             spree.admin_product_images_url(@product)
           end
         end
    end
  end
end

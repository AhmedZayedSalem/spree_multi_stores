module Spree

    class ImagesController < ResourceController
      before_action :load_edit_data, except: :index
      before_action :load_index_data, only: :index
      before_action :load_shop
      create.before :set_viewable
      update.before :set_viewable

      private		
      def load_shop
        @shop = Shop.friendly.find(@product.shop_id)  
      end
      def location_after_destroy
        spree.shop_product_images_url(@shop, @product)
      end

      def location_after_save
        spree.shop_product_images_url(@shop, @product)
      end
    
      def load_index_data
        @product = Product.friendly.includes(*variant_index_includes).find(params[:product_id])
      end

      def load_edit_data
        @product = Product.friendly.includes(*variant_edit_includes).find(params[:product_id])
        @variants = @product.variants.map do |variant|
          [variant.sku_and_options_text, variant.id]
        end
        @variants.insert(0, [Spree.t(:all), @product.master.id])
      end

      def set_viewable
        @image.viewable_type = 'Spree::Variant'
        @image.viewable_id = params[:image][:viewable_id]
      end

      def variant_index_includes
        [
          variant_images: [viewable: { option_values: :option_type }]
        ]
      end

      def variant_edit_includes
        [
          variants_including_master: { option_values: :option_type, images: :viewable }
        ]
      end
    end

end

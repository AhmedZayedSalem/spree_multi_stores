module Spree
  module Admin
    ProductsController.class_eval do
      belongs_to 'spree/shop', :find_by => :slug
      update.after :update_after
      def update
        if params[:product][:taxon_ids].present?
          params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].split(',')
        end
        if params[:product][:branch_ids].present?
          params[:product][:branch_ids] = params[:product][:branch_ids].split(',')
        end
        if params[:product][:branch_ids].empty?
           @product.all_branches = 0
        elsif params[:product][:branch_ids].length == @shop.branches.length
           @product.all_branches = 2
        else          
           @product.all_branches = 1
        end               
        invoke_callbacks(:update, :before)
        @shop = Shop.friendly.find(@product.shop_id)  
        if @object.update_attributes(permitted_resource_params)
          invoke_callbacks(:update, :after)
          flash[:success] = flash_message_for(@object, :successfully_updated)
          respond_with(@object) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end

        else
          # Stops people submitting blank slugs, causing errors when they try to
          # update the product again
          @product.slug = @product.slug_was if @product.slug.blank?
          invoke_callbacks(:update, :fails)
          respond_with(@object)
        end
      end
      def load_data
        @shop = parent
        @branches = @shop.branches
        @taxons = Taxon.order(:name)
        @option_types = OptionType.order(:name)
        @tax_categories = TaxCategory.order(:name)
        @shipping_categories = ShippingCategory.order(:name)

        

      end
      def location_after_save
        spree.edit_admin_shop_product_url(@shop,@product)
      end
      def update_before
        # note: we only reset the product properties if we're receiving a post
        #       from the form on that tab
      
        @product.set_preference(:new_arrival, params[:product][:preferred_new_arrival])
        @product.set_preference(:on_sale, params[:product][:preferred_on_sale])
        @product.set_preference(:on_trial, params[:product][:preferred_on_trial])
        @product.set_preference(:returnable, params[:product][:preferred_returnable])

        return unless params[:clear_product_properties]
        params[:product] ||= {}
      end
      def create_before
        return if params[:product][:prototype_id].blank?
        @prototype = Spree::Prototype.find(params[:product][:prototype_id])
        @product.branches = @shop.branches        
      end
      def update_after

      end
    end
  end
end

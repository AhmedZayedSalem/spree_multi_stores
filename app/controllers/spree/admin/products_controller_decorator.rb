module Spree
  module Admin
    ProductsController.class_eval do
      belongs_to 'spree/shop', :find_by => :slug
      update.after :update_after


      def index
        if params[:shop_id] != nil
          
          @shop = parent
        end
        session[:return_to] = request.url
        respond_with(@collection)
      end
      def update
        if params[:product][:taxon_ids].present?
          params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].split(',')
        end
        if params[:shop_id] != nil
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
    
        end       
        invoke_callbacks(:update, :before)
        if params[:shop_id] != nil
          @shop = Shop.friendly.find(@product.shop_id) 
        end 
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

        if params[:shop_id] != nil
         
          @shop = parent
          @branches = @shop.branches
          @taxons = Taxon.order(:name)
          @option_types = OptionType.order(:name)
          @tax_categories = TaxCategory.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
        else
          @taxons = Taxon.order(:name)
          @option_types = OptionType.order(:name)
          @tax_categories = TaxCategory.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
        end
        

      end
      def location_after_save
        if params[:shop_id] != nil
          spree.edit_admin_shop_product_url(@shop,@product)
        else
          spree.edit_admin_product_url(@product)
        end
      end
      def update_before
        # note: we only reset the product properties if we're receiving a post
        #       from the form on that tab
      

        return unless params[:clear_product_properties]
        params[:product] ||= {}
      end
      def create_before
        if params[:shop_id] != nil
          return if params[:product][:prototype_id].blank?
          @prototype = Spree::Prototype.find(params[:product][:prototype_id])
          @product.branches = @shop.branches  
        else
          return if params[:product][:prototype_id].blank?
          @prototype = Spree::Prototype.find(params[:product][:prototype_id])
        end      
      end
      def update_after

      end
    end
  end
end

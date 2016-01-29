module Spree
  
   class ShopsController < ResourceController
       
     before_action :load_data, except: :index
     create.before :create_before
     update.before :update_before
     before_action :authorize_retailer, except: [:index, :show]
     respond_to :html
     def show
      
      session[:return_to] ||= request.referer

     end

     def index
        session[:return_to] = request.url
        respond_with(@collection)
     end

      
     def update
       invoke_callbacks(:update, :before)
       if @object.update_attributes(permitted_resource_params)
         invoke_callbacks(:update, :after)
         flash[:success] = flash_message_for(@object, :successfully_updated)
         respond_with(@object) do |format|
           format.html { redirect_to location_after_save }
           format.js   { render layout: false }
         end
       else
           
         invoke_callbacks(:update, :fails)
         respond_with(@object)
       end
     end       
     protected
     def load_data
       @shop = Spree::Shop.friendly.find(params[:id])
       
       @products = @shop.products
       @branches = @shop.branches
     end
     def create_before
        
     end
      
     def collection
       return @collection if @collection.present?
       params[:q] ||= {}
       params[:q][:deleted_at_null] ||= "1"

       params[:q][:s] ||= "name asc"
       @collection = super
       # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
       # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
       if params[:q][:deleted_at_null] == '0'
         @collection = @collection.with_deleted
       end
      # @search needs to be defined as this is passed to search_form_for
      # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
      # This is to include all products and not just deleted products.
       @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
       @collection = @search.result.
             distinct_by_shop_ids(params[:q][:s]).              
             page(params[:page]).
             per(params[:per_page] || Spree::Config[:shops_per_page])
       @collection
     end
     def authorize_retailer
       
       if respond_to?(:model_class, true) && model_class
         record = model_class
       else
         record = controller_name.to_sym
       end

       authorize! action, record
     end       
     def action
       params[:action].to_sym
     end   
     def update_before
       # note: we only reset the product properties if we're receiving a post
       #       from the form on that tab
       return unless params[:clear_shop_properties]
       params[:shop] ||= {}
     end
     def find_resource
       Shop.with_deleted.friendly.find(params[:id])
     end
     def location_after_save
       spree.edit_shop_url(@shop)
     end
   end
end

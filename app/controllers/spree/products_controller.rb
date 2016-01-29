module Spree
  class ProductsController < Spree::ResourceController
    before_action :load_product, only: :show
    before_action :load_taxon, only: :index
    before_action :load_data, except: [:index, :show]
    create.before :create_before
    update.before :update_before
    helper_method :clone_object_url
    before_action :authorize_retailer, except: [:index, :show]
    belongs_to 'spree/shop', :find_by => :slug
    update.after :update_after
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/taxons'

    respond_to :html
    skip_before_action :set_current_order, only: :cart_link

    def unauthorized
      render 'spree/shared/unauthorized', layout: Spree::Config[:layout], status: 401
    end

    def cart_link
      render partial: 'spree/shared/link_to_cart'
      fresh_when(simple_current_order)
    end
    def index
      
      
      
      if params[:shop_id] == nil
        
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
      else
        @shop = Spree::Shop.friendly.find(params[:shop_id])
        @taxonomies = Spree::Taxonomy.includes(root: :children)
        
        session[:return_to] = request.url
        respond_with(@collection)
       
      end     
    end

    def show
     
      
      if params[:shop_id] == nil
        @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
        @product_properties = @product.product_properties.includes(:property)
        @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
      else
        @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
        @product_properties = @product.product_properties.includes(:property)
        @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
      end
      redirect_if_legacy_path
    end
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
        if params[:product][:branch_ids].present?
          if params[:product][:branch_ids].empty?
             @product.all_branches = 0
          elsif params[:product][:branch_ids].length == @shop.branches.length
             @product.all_branches = 2
          else          
             @product.all_branches = 1
          end  
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

      def destroy
        @product = Product.friendly.find(params[:id])
        @product.destroy

        flash[:success] = Spree.t('notice_messages.product_deleted')

        respond_with(@product) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
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
        spree.edit_shop_product_url(@shop,@product)
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
      def clone
        @new = @product.duplicate

        if @new.save
          flash[:success] = Spree.t('notice_messages.product_cloned')
        else
          flash[:error] = Spree.t('notice_messages.product_not_cloned')
        end

        redirect_to edit_product_url(@new)
      end

      def stock
        @variants = @product.variants.includes(*variant_stock_includes)
        @variants = [@product.master] if @variants.empty?
        @stock_locations = StockLocation.accessible_by(current_ability, :read)
        if @stock_locations.empty?
          flash[:error] = Spree.t(:stock_management_requires_a_stock_location)
          redirect_to stock_locations_path
        end
      end
    private

      def accurate_title
        if @product
          @product.meta_title.blank? ? @product.name : @product.meta_title
        else
          super
        end
      end
      def authorize_retailer
        
        if respond_to?(:model_class, true) && model_class
          record = model_class
        else
          record = controller_name.to_sym
        end
        authorize! :retailer, record
        authorize! action, record
      end
      def load_product
        if try_spree_current_user.try(:has_spree_role?, "admin")
          @products = Product.with_deleted

          
          if params[:shop_id] != nil
            @shop = parent
            @branches = @shop.branches
            @taxons = Taxon.order(:name)
            @option_types = OptionType.order(:name)
            @tax_categories = TaxCategory.order(:name)
            @shipping_categories = ShippingCategory.order(:name)
          end
        else
          @products = Product.active(current_currency)
          
      
          if params[:shop_id] != nil
            @shop = parent
            @branches = @shop.branches
          end
        end
        @product = @products.friendly.find(params[:id])
        
      end

      def load_taxon
        @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
      end

      def redirect_if_legacy_path
        # If an old id or a numeric id was used to find the record,
        # we should do a 301 redirect that uses the current friendly id.
        if params[:id] != @product.friendly_id
          params.merge!(id: @product.friendly_id)
          return redirect_to url_for(params), status: :moved_permanently
        end
      end
    protected
      # This method is placed here so that the CheckoutController
      # and OrdersController can both reference it (or any other controller
      # which needs it)
      def apply_coupon_code
        if params[:order] && params[:order][:coupon_code]
          @order.coupon_code = params[:order][:coupon_code]

          handler = PromotionHandler::Coupon.new(@order).apply

          if handler.error.present?
            flash.now[:error] = handler.error
            respond_with(@order) { |format| format.html { render :edit } } and return
          elsif handler.success
            flash[:success] = handler.success
          end
        end
      end

      def config_locale
        Spree::Frontend::Config[:locale]
      end

      def find_resource
        Product.with_deleted.friendly.find(params[:id])
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
              distinct_by_product_ids(params[:q][:s]).
              includes(product_includes).
              page(params[:page]).
              per(params[:per_page] || Spree::Config[:products_per_page])
        @collection
      end

      def update_before
        # note: we only reset the product properties if we're receiving a post
        #       from the form on that tab
        return unless params[:clear_product_properties]
        params[:product] ||= {}
      end

      def product_includes
        [{ variants: [:images], master: [:images, :default_price] }]
      end

      def clone_object_url(resource)
        clone_product_url resource
      end
      def flash_message_for(object, event_sym)
        resource_desc  = object.class.model_name.human
        resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
        Spree.t(event_sym, resource: resource_desc)
      end
      def load_resource
        if params[:shop_id] != nil
          if member_action?
            @object ||= load_resource_instance

            # call authorize! a third time (called twice already in Admin::BaseController)
            # this time we pass the actual instance so fine-grained abilities can control
            # access to individual records, not just entire models.
            authorize! action, @object

            instance_variable_set("@#{resource.object_name}", @object)
          else
      
            @collection ||= collection

            # note: we don't call authorize here as the collection method should use
            # CanCan's accessible_by method to restrict the actual records returned

            instance_variable_set("@#{controller_name}", @collection)
          end 
        else
        end
      end 
      private

      def variant_stock_includes
        [:images, stock_items: :stock_location, option_values: :option_type]
      end
  end
end

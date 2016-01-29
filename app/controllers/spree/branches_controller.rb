module Spree
 
    class BranchesController < ResourceController
      belongs_to 'spree/shop', :find_by => :slug
      new_action.before :new_before
      before_action :load_data, only: [:new, :create, :edit, :update]
      before_action :authorize_retailer

      before_action :generate_api_key
      # override the destroy method to set deleted_at value
      # instead of actually deleting the shop.
      def destroy
        @branch = Branch.find(params[:id])
        if @branch.destroy
          flash[:success] = Spree.t('notice_messages.branch_deleted')
        else
          flash[:success] = Spree.t('notice_messages.branch_not_deleted')
        end

        respond_with(@branch) do |format|
          format.html { redirect_to shop_branches_url(params[:branch_id]) }
          format.js  { render_js_for_destroy }
        end
      end

      protected
        def new_before
        
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
      def action
        params[:action].to_sym
      end

        def collection
          @deleted = (params.key?(:deleted) && params[:deleted] == "on") ? "checked" : ""

          if @deleted.blank?
            @collection ||= super
          else
            @collection ||= Branch.only_deleted.where(:shop_id => parent.id)
          end
          @collection
        end
      # Need to generate an API key for a user due to some backend actions
      # requiring authentication to the Spree API
      def generate_api_key
        if (user = try_spree_current_user) && user.spree_api_key.blank?
          user.generate_spree_api_key!
        end
      end

      def flash_message_for(object, event_sym)
        resource_desc  = object.class.model_name.human
        resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
        Spree.t(event_sym, resource: resource_desc)
      end

      def render_js_for_destroy
        render partial: '/spree/shared/destroy'
      end

      # Index request for JSON needs to pass a CSRF token in order to prevent JSON Hijacking
      def check_json_authenticity
        return unless request.format.js? || request.format.json?
        return unless protect_against_forgery?
        auth_token = params[request_forgery_protection_token]
        unless auth_token && form_authenticity_token == URI.unescape(auth_token)
          raise(ActionController::InvalidAuthenticityToken)
        end
      end

      private
    
        def load_data

        end
    end

end

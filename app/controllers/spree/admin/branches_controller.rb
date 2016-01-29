module Spree
  module Admin
    class BranchesController < ResourceController
      belongs_to 'spree/shop', :find_by => :slug
      new_action.before :new_before
      before_action :load_data, only: [:new, :create, :edit, :update]

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
          format.html { redirect_to admin_shop_branches_url(params[:branch_id]) }
          format.js  { render_js_for_destroy }
        end
      end

      protected
        def new_before
        
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

      private
        def load_data

        end
    end
  end
end

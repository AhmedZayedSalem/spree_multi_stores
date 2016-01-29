module Spree
  module Api
    class BranchesController < Spree::Api::BaseController
      before_action :shop, except: [:update, :destroy]
      def index
        if params[:ids]
          @branches = @shop.branches.accessible_by(current_ability, :read).where(id: params[:ids].split(','))
        else
          @branches = @shop.branches.accessible_by(current_ability, :read).load.ransack(params[:q]).result
        end
        respond_with(@branches)
      end  
  
      def show
         @branches = @shop.branches.accessible_by(current_ability, :read).find(params[:id])
        respond_with(@branches)
      end

      def jstree
        show
      end


      def create
        authorize! :create, Spree::Branch
        @branches = @shop.branches.new(branch_params)
        if @branch.save
          render :show, :status => 201
        else
          invalid_resource!(@branch)
        end
      end

      def update
        @branch = Spree::Branch.accessible_by(current_ability, :update).find(params[:id])
        if @branch.update_attributes(branch_params)
          render :show
        else
          invalid_resource!(@branch)
        end
      end


      def destroy
        @branch = Spree::Branch.accessible_by(current_ability, :destroy).find(params[:id])
        @branch.destroy
        render :text => nil, :status => 204
      end

  
      private

        def shop
          render 'spree/api/shared/stock_location_required', status: 422 and return unless params[:shop_id]
          @shop ||= Spree::Shop.accessible_by(current_ability, :read).find(params[:shop_id])
        end
        def branch_params
          params.require(:branch).permit(branch_attributes)
        end
    end
  end
end

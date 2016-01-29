module Spree
  module Api
    class ShopsController < Spree::Api::BaseController

      def index
        if params[:ids]
          @shops = Spree::Shop.accessible_by(current_ability, :read).where(id: params[:ids].split(','))
        else
          @shops = Spree::Shop.accessible_by(current_ability, :read).load.ransack(params[:q]).result
        end
        respond_with(@shops)
      end  
  
      def show
         @shops = Spree::Shop.accessible_by(current_ability, :read).find(params[:id])
        respond_with(@shops)
      end

      def jstree
        show
      end


      def create
        authorize! :create, Spree::Shop
        @shops = Spree::Shop.new(shop_params)
        if @shop.save
          render :show, :status => 201
        else
          invalid_resource!(@shop)
        end
      end

      def update
        @shop = Spree::Shop.accessible_by(current_ability, :update).find(params[:id])
        if @shop.update_attributes(shop_params)
          render :show
        else
          invalid_resource!(@shop)
        end
      end


      def destroy
        @shop = Spree::shop.accessible_by(current_ability, :destroy).find(params[:id])
        @shop.destroy
        render :text => nil, :status => 204
      end

  
      private

        def shop_params
          params.require(:shop).permit(shop_attributes)
        end
    end
  end
end

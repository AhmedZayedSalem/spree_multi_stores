module Spree
  class ShopsController < ResourceController
    before_action :load_shop, only: :show
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    respond_to :html
    def index
      @shops = Shop.all
    end
  
    def show
      @shop = Shop.friendly.find(params[:id])
      @products = @shop.products.all
    end
    
    def load_shop
       @shop = Shop.friendly.find(params[:id])
    end
  end
end

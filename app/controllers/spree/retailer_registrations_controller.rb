class Spree::RetailerRegistrationsController < Devise::RegistrationsController
  helper 'spree/base'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  before_filter :check_permissions, :only => [:edit, :update]
  skip_before_filter :require_no_authentication
  before_action :create_shop, :only => :new
  before_action :param_shop, :only => :create
  # GET /resource/sign_up
  def new
    super
    @user = resource 
  end

  # POST /resource/sign_up
  def create
    @user = build_resource(spree_user_params)
    @role = Spree::Role.find_by_name("retailer")
    @user.spree_roles << @role

    if resource.save
      @shop = Spree::Shop.create(:name => params[:spree_user][:shop_name], :user_id => @user.id)
      set_flash_message(:notice, :signed_up)
      if current_order
        current_order.associate_user! @user
      end
      sign_in(:spree_user, @user)
      session[:spree_user_signup] = true
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end
  def shop_name
    @shop.name
  end
  protected

  def check_permissions
    authorize!(:create, resource)
  end

  private

  def spree_user_params
    params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes)
  end
  def shop_params
     params.require(:spree_shop).permit(Spree::PermittedAttributes.shop_attributes)
  end
  def create_shop
    @shop = Spree::Shop.new
  end
  def param_shop
    
  end
end

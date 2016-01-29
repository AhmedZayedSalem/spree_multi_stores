require 'cancan'
require_dependency 'spree/core/controller_helpers/strong_parameters'

class Spree::BaseController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Search
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::StrongParameters

  respond_to :html

  protected
  def action
    params[:action].to_sym
  end
      def flash_message_for(object, event_sym)
        resource_desc  = object.class.model_name.human
        resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
        Spree.t(event_sym, resource: resource_desc)
      end

      def render_js_for_destroy
        render partial: '/spree/shared/destroy'
      end
end

require 'spree/i18n/initializer'

require "application_responder"

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  rescue_from CanCan::AccessDenied do |exeption|
    redirect_to root_url, alert: exeption.message
  end
  check_authorization unless :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  def gon_user
    gon.user_id = current_user.id if current_user
  end

end

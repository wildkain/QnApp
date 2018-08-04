require "application_responder"

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :gon_user, unless: :devise_controller?

  check_authorization unless :devise_controller?

  rescue_from CanCan::AccessDenied do |exeption|
    respond_to do |format|
      format.html { redirect_to root_path, notice: exeption.message }
      format.json { head :forbidden }
      format.js { head :forbidden }
    end
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end

end

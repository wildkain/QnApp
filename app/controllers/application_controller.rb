# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end

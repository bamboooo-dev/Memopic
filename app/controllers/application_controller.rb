class ApplicationController < ActionController::Base
  before_action :store_current_location, unless: :devise_controller?

  private
    def store_current_location
      return if current_user
      store_location_for(:user, request.url) if request.get?
    end
end

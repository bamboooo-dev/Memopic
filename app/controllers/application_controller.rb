class ApplicationController < ActionController::Base
  before_action :store_current_location, unless: :devise_controller?

  def response_success(class_name, action_name)
    render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
  end
  
  private
    def store_current_location
      return if current_user
      store_location_for(:user, request.url) if request.get?
    end
end

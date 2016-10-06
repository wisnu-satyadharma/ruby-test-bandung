class ApplicationController < ActionController::Base
	include SimpleCaptcha::ControllerHelpers
  protect_from_forgery with: :exception
  before_action :authenticate_user!
	layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "authentication"
    else
      "application"
    end
  end  
end

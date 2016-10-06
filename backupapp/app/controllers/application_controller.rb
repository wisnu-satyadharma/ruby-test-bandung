class ApplicationController < ActionController::Base
	include SimpleCaptcha::ControllerHelpers
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end

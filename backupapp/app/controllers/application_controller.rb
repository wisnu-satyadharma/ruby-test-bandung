class ApplicationController < ActionController::Base
	include SimpleCaptcha::ControllerHelpers
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_header_info
	layout :layout_by_resource

  def set_header_info
    return nil if current_user.blank?
    @total_profile_count = Profile.joins(:user).where(user_id: current_user.id).count
    @total_files_count =Attachment.joins(:document => [:profile => [:user]]).where("users.id = ?",current_user.id).count
    @total_user_count = User.count
    @total_user_storage = Filesize.from("#{Document.joins(:profile =>[:user]).where("users.id = ?",current_user.id).collect(&:file_size).compact.sum} B").pretty 
  end

  protected

  def layout_by_resource
    if devise_controller?
      "authentication"
    else
      "application"
    end
  end  
end

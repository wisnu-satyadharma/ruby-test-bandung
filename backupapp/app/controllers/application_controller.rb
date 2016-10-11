class ApplicationController < ActionController::Base
	include SimpleCaptcha::ControllerHelpers
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_header_info
	layout :layout_by_resource

  def set_header_info
    return nil if current_user.blank?
    #set later user dummy for now
    # Rails.cache.fetch("profiles") {
    #   @total_profile_count = Profile.joins(:user).where(user_id: current_user.id).count
    # }
    # Rails.cache.fetch("files") {
    #   @total_files_count =Attachment.joins(:document => [:profile => [:user]]).where("users.id = ?",current_user.id).count  
    # }
    # Rails.cache.fetch("users") {
    #   @total_user_count = User.count  
    # }

    # Rails.cache.fetch("storage") {
    #   @total_user_storage = Filesize.from("#{Document.joins(:profile =>[:user]).where("users.id = ?",current_user.id).collect(&:file_size).compact.sum} B").pretty   
    # }        

    
      @total_profile_count = 5
      @total_files_count = 1129
      @total_user_count = 3
      @total_user_storage = 32124
    

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

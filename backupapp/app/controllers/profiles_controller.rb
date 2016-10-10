class ProfilesController < ApplicationController
  before_action :get_profile, only: [:edit, :update, :backup_now, :show]

  def show
    if params[:document_id].present?
      @document = Document.find_by(id: params[:document_id])
    else
      @document = @profile.documents.order("version desc").first
    end
    @documents_options = @profile.documents.order("version asc")

    if @document.present?
      @new_files = @document.attachments.where(status: Attachment.statuses["added"])
      @modified_files = @document.attachments.where(status: Attachment.statuses["modified"])
    end
  end

  def index    
  	@profiles = current_user.profiles
  end

  def new
  	@profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      redirect_to profiles_path, notice: 'Profile was successfully created.'
    else
    	flash[:alert] = "Profile Failed to Create, #{@profile.errors.full_messages.join(",")}"
      render :new
    end
  end

  def edit
  end

  def update    
    if @profile.update_attributes(profile_params)
      redirect_to profiles_path, notice: 'Profile was successfully updated.'
    else
      flash[:alert] = "Profile failed to update, #{@profile.errors.full_messages.join(",")}"
      render :edit
    end
  end

  def backup_now
    if File.exists?(@profile.directory)
      @profile.backup_now!
      flash[:notice] = 'Please wait! Backup process finish soon.'      
    else
      flash[:alert] = 'Backup process failed to start, please check your directory.'      
    end    
    redirect_to profiles_path
  end

  protected

  def get_profile
    @profile = Profile.find_by(id: params[:id])  
  end

  def profile_params
    params.require(:profile).permit(:user_id, :name, :directory, :exclusion)
  end

  
end

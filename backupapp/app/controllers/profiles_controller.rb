class ProfilesController < ApplicationController
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

  protected
  def profile_params
    params.require(:profile).permit(:user_id, :name, :directory, :exclusion)
  end

  
end

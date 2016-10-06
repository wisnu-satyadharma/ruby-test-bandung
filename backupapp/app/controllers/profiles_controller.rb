class ProfilesController < ApplicationController
  def index
  	@profiles = current_user.profiles
  end

  def new
  	
  end

  def create
  end

  protected
  
end

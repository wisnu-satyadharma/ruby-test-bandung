class AttachmentsController < ApplicationController
  def show_contain
  	@attachment = Attachment.find_by(id: params[:id])  	
  end
end

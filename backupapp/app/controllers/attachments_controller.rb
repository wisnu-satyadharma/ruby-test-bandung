class AttachmentsController < ApplicationController
  def show_contain
  	@attachment = Attachment.find_by(id: params[:id])  	
  	puts Paperclip.io_adapters.for(@attachment.item).read
  end
end

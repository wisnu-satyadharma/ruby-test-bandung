class AttachmentsController < ApplicationController
  def show_contain
  	@attachment = Attachment.find_by(id: params[:id])  	
  end

  def show_different
  	attachment = Attachment.find_by(id: params[:id])
  	current_document = attachment.document
  	previous_attachment = Attachment.joins(:document => [:profile]).
  			where("documents.version = ? and attachments.file_path = ?",
  				current_document.version-1,
  				attachment.file_path).first
  	current_text = Paperclip.io_adapters.for(attachment.item).read
  	prev_text = Paperclip.io_adapters.for(previous_attachment.item).read
  	@modified_text = TextRequest.diff(current_text,prev_text)
  end
end

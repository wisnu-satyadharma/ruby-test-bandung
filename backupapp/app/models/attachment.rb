class Attachment < ApplicationRecord
	belongs_to :document, optional: true
	belongs_to :parent, :class_name => 'Attachment', :foreign_key => :parent_id, optional: true
	has_many :children, :class_name => 'Attachment', :foreign_key => :parent_id

	enum object_type: { file: 0, directory: 1 }
	enum status: {added: 0, modified: 1}
	has_attached_file :item
	do_not_validate_attachment_file_type :item

	after_save :update_upload_progress

	def update_upload_progress
		return true if self.document.blank?		
		return true if self.object_type != "file"		
		document = self.document		
		current_upload_size_progress = document.upload_size_progress.to_f + self.file_size.to_f
		current_percentage_progress = (current_upload_size_progress * 100 / document.file_size).to_f
		document.update_attributes(upload_size_progress: current_upload_size_progress, upload_percentage_progress: current_percentage_progress)
		return true
	end
	

end

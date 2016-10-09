class Profile < ApplicationRecord
	belongs_to :user
	has_many :documents

	validates :name, presence: true
	validates :directory, presence: true

	def backup_now!
		#check latest document
		if self.documents.blank?
			current_document = self.documents.create(status: Document.statuses["in_progress"], version: 1, backup_date: Time.now)
		else
			last_document = self.documents.order("version desc").first
			version = last_document.version + 1
			current_document = self.documents.create(status: Document.statuses["in_progress"], version: version, backup_date: Time.now)
		end		
		file_number, file_size = RequestFile.calculating_file(self.directory)
		current_document.update_column(:file_number, file_number)
		current_document.update_column(:file_size, file_size)
		RequestFile.process_backup(self.directory, current_document.id)
	end
end

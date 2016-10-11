class Profile < ApplicationRecord
	belongs_to :user
	has_many :documents

	validates :name, presence: true
	validates :directory, presence: true
	before_save :remove_white_space

	def backup_now!
		if self.documents.blank?
			current_document = self.documents.create(status: Document.statuses["calculating"], version: 1, backup_date: Time.now)
		else
			last_document = self.documents.order("version desc").first
			version = last_document.version + 1
			current_document = self.documents.create(status: Document.statuses["calculating"], version: version, backup_date: Time.now)
		end		
		file_number, file_size = RequestFile.calculating_file(self.directory, current_document.profile_id)
		current_document.update_attributes(file_number: file_number, file_size: file_size, status: Document.statuses["in_progress"])
		RequestFile.process_backup(self.directory, current_document.id)
		current_document.update_attribute(:status,Document.statuses["done"])
	end

	def has_process_backup?
		self.documents.calculating.present? || self.documents.in_progress.present?
	end

	def backup_progress
		self.documents.in_progress.last.try(:upload_percentage_progress)
	end

	protected

	def remove_white_space
		self.exclusion = self.exclusion.gsub(" ","").gsub("\n","").gsub("\r","") if self.exclusion.present?
		self.directory = self.directory.gsub(" ","").gsub("\n","").gsub("\r","") if self.directory.present?
	end
end

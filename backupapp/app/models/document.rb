class Document < ApplicationRecord
	belongs_to :profile
	has_many :attachments

	enum status: { in_progress: 0, calculating: 1, done: 2 }

	def root_attachments
		self.attachments.where("parent_id is null")
	end

	def tree_view_list
		return "" if self.root_attachments.blank?
		html = ""
		self.root_attachments.each do |attachment|
			puts attachment.id
			html << TreeviewConverter.convert(attachment.id)
		end
		return html.html_safe
	end

end

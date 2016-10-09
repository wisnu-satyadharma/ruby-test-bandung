class Document < ApplicationRecord
	belongs_to :profile
	has_many :attachments

	enum status: { in_progress: 0, calculating: 1, done: 2 }
end

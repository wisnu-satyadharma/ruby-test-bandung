class Profile < ApplicationRecord
	belongs_to :user

	validates :name, presence: true
	validates :directory, presence: true
end

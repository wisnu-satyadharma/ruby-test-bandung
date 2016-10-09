class Attachment < ApplicationRecord
	belongs_to :document
	belongs_to :parent, :class_name => 'Attachment', :foreign_key => :parent_id
	has_many :children, :class_name => 'Attachment', :foreign_key => :parent_id

	enum object_type: { file: 0, directory: 1 }
	has_attached_file :item
	do_not_validate_attachment_file_type :item

	attr_accessor :item_file_name
end

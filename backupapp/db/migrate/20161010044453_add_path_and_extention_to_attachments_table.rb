class AddPathAndExtentionToAttachmentsTable < ActiveRecord::Migration[5.0]
  def change
  	add_column :attachments, :file_path, :string
  	add_column :attachments, :status, :integer
  end
end

class UploadSizeProgressAndUploadPercentageProgressToDocument < ActiveRecord::Migration[5.0]
  def change
  	remove_column :documents, :upload_progress
  	add_column :documents, :upload_size_progress, :float
  	add_column :documents, :upload_percentage_progress, :float
  end
end

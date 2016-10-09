class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
    	t.references :profile
    	t.integer :file_number
    	t.integer :file_size
    	t.float :upload_progress
    	t.integer :status
    	t.integer :version
    	t.datetime :backup_date
      t.timestamps
    end
  end
end

class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
    	t.references :document
    	t.integer :file_size
    	t.integer :object_type
    	t.integer :parent_id, null: true
      t.timestamps
    end
    add_attachment :attachments, :item
  end
end

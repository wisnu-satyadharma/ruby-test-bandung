class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
    	t.references :user
    	t.string :name
    	t.string :directory
    	t.string :exclusion
      t.timestamps
    end
  end
end

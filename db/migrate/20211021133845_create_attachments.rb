class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.string :attachable_type
      t.integer :attachable_id
      t.string :description
      t.string :image_size
      t.integer :position
      t.integer :asset_id

      t.timestamps
    end
  end
end

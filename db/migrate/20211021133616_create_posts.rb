class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :position
      t.integer :parent_id, default: 0
      t.integer :user_id
      t.boolean :active, default: 0

      t.timestamps
    end
  end
end

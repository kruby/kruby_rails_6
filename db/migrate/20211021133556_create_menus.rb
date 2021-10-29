class CreateMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.string :title
      t.text :body
      t.boolean :active

      t.timestamps
    end
  end
end

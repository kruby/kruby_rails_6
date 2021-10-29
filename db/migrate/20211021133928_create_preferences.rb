class CreatePreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :preferences do |t|
      t.string :name
      t.string :value
      t.integer :user_id

      t.timestamps
    end
  end
end

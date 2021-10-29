class CreateHours < ActiveRecord::Migration[6.1]
  def change
    create_table :hours do |t|
      t.string :description
      t.decimal :number, :decimal, precision: 10, scale: 2
      t.date :date
      t.integer :user_id
      t.integer :partner_id

      t.timestamps
    end
  end
end

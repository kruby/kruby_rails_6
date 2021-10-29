class CreateVouchers < ActiveRecord::Migration[6.1]
  def change
    create_table :vouchers do |t|
      t.string :description
      t.decimal :number, :decimal, precision: 10, scale: 2
      t.integer :partner_id
      t.date :date
      t.integer :user_id
      t.integer :hourly_rate

      t.timestamps
    end
  end
end

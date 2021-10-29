class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.boolean :active
      t.string :category
      t.string :blogname
      t.string :password_hash
      t.string :password_salt

      t.timestamps
    end
  end
end

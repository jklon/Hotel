class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.integer :user_id
      t.string :number
      t.string :auth_token
      t.integer :otp
      t.string :device_id

      t.timestamps null: false
    end

    add_index :auth_tokens, :user_id
    add_index :auth_tokens, :auth_token
  end
end

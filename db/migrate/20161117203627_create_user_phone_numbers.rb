class CreateUserPhoneNumbers < ActiveRecord::Migration
  def change
    create_table :user_phone_numbers do |t|
      t.integer :user_id
      t.string :number

      t.timestamps null: false
    end

    add_index :user_phone_numbers, :number
    add_index :user_phone_numbers, :user_id
  end
end

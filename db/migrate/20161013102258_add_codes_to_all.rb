class AddCodesToAll < ActiveRecord::Migration
  def change
    add_column :chapters, :code, :string
    add_column :topics, :code, :string
    add_column :sub_topics, :code, :string
    add_column :standards, :code, :string
    add_column :subjects, :code, :string

    add_index :chapters, :code, :unique => true
    add_index :topics, :code, :unique => true
    add_index :sub_topics, :code, :unique => true
    add_index :standards, :code, :unique => true
    add_index :subjects, :code, :unique => true
  end
end

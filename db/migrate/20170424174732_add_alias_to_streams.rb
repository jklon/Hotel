class AddAliasToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :alias, :string
  end
end

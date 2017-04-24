class AddAliasSequenceToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :alias, :string
    add_column :chapters, :sequence, :integer
  end
end

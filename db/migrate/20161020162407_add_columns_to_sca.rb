class AddColumnsToSca < ActiveRecord::Migration
  def change
    add_column :short_choice_answers, :label, :string
    add_column :short_choice_answers, :image, :string
  end
end

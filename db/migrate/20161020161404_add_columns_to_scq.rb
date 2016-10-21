class AddColumnsToScq < ActiveRecord::Migration
  def change
    add_column :short_choice_questions, :passage_image, :string
    add_column :short_choice_questions, :question_image, :string
    add_column :short_choice_questions, :hint_available, :boolean
    add_column :short_choice_questions, :passage_footer, :text
    add_column :short_choice_questions, :linked_question_tid, :integer
    add_column :short_choice_questions, :sequence_no, :integer
    add_column :short_choice_questions, :assertion, :string
    add_column :short_choice_questions, :hint, :text
    add_column :short_choice_questions, :passage, :text
    add_column :short_choice_questions, :solution_rating, :integer
    add_column :short_choice_questions, :correct_answer_id, :integer
    add_column :short_choice_questions, :passage_header, :string
    add_column :short_choice_questions, :answer_image, :string
    add_column :short_choice_questions, :reason, :text
    add_column :short_choice_questions, :hint_image, :string
    add_column :short_choice_questions, :multiple_correct, :boolean
    add_column :short_choice_questions, :question_style, :string
    add_column :short_choice_questions, :level, :integer
    add_column :short_choice_questions, :answer_available, :boolean
    add_column :short_choice_questions, :answer, :text
    add_column :short_choice_questions, :question_linked, :boolean
    add_column :short_choice_questions, :question_tid, :integer
  end
end

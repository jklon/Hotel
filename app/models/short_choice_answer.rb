class ShortChoiceAnswer < ActiveRecord::Base
  belongs_to :short_choice_question
  before_update :copy_answer_text

  def copy_answer_text
    if answer_text_changed?
      self.answer_text_old = answer_text_was
    end
  end

end

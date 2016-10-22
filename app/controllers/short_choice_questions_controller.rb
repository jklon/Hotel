class ShortChoiceQuestionsController < ApplicationController

  def index
    # @questions = ShortChoiceQuestion.get_questions(@topic, @chapter)
    @filterrific = initialize_filterrific(
      ShortChoiceQuestion,
      params[:filterrific],
      select_options: {
        with_topic_id: ShortChoiceQuestion.options_for_topics,
        with_chapter_id: ShortChoiceQuestion.options_for_chapters,
        with_difficulty: ShortChoiceQuestion.options_for_difficulty,
        with_level: ShortChoiceQuestion.options_for_levels,
        with_subject_id: ShortChoiceQuestion.options_for_subjects
      },
    ) or return

    @questions = @filterrific.find
    @questions = @questions.includes(:short_choice_answers)
    @questions = @questions.paginate(:page => params[:page], :per_page => 10)
  end

end

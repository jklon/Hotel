class ShortChoiceQuestionsController < ApplicationController
  before_filter :find_short_choice_question, only: [:update]

  def index
    # @questions = ShortChoiceQuestion.get_questions(@topic, @chapter)
    params[:filterrific] ||= {}
    @filterrific = initialize_filterrific(
      ShortChoiceQuestion,
      params[:filterrific],
      select_options: {
        with_topic_id: ShortChoiceQuestion.options_for_topics(params[:filterrific][:with_chapter_id]),
        with_chapter_id: ShortChoiceQuestion.options_for_chapters(params[:filterrific][:with_standard_id]),
        with_difficulty: ShortChoiceQuestion.options_for_difficulty,
        with_level: ShortChoiceQuestion.options_for_levels,
        with_standard_id: ShortChoiceQuestion.options_for_standards
      },
    ) or return

    @questions = @filterrific.find
    @questions = @questions.includes(:short_choice_answers)
    @questions = @questions.paginate(:page => params[:page], :per_page => 10)
  end

  def update
    if @scq.update(short_choice_question_params)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render "xhr_update_fail", status: :bad_request}
      end
    end
  end

  private

  def short_choice_question_params
    params.require(:short_choice_question).permit(:reference_solving_time, :level, :difficulty, :include_in_diagnostic_test,
     :topic_id, :question_text, :id, {:short_choice_answers_attributes => [:answer_text, :label, :id]})
  end

  def find_short_choice_question
    @scq = ShortChoiceQuestion.find_by_id(params[:short_choice_question_id] || params[:id])
    render nothing: true, status: :not_found unless @scq.present?
  end
end

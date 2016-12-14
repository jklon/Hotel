class Api::WorksheetController < ApiController
  def get_worksheet
    @worksheet = Worksheet.includes(short_choice_questions: [:short_choice_answers])
    .where(:id => params[:worksheet_id]).first
  end
end

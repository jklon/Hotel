class Api::WorksheetController < ApiController
  def get_worksheet
    @worksheet = Worksheet.includes(short_choice_questions: [:short_choice_answers]).where(:id => params[:worksheet_id]).first
  end
  
  def worksheet_attempt
  	user_params_sane? params[:user]
    @user = User.find_or_create_temp_user(params[:user])

    attempt = UserWorksheetAttempt.create!(:user => @user, :worksheet_id => params[:worksheet][:id])
    DifficultyLevel.where(:value => (params[:worksheet][:difficultywise_breakup]).keys).each do |level|
      DifficultywiseWorksheetBreakup.create!(:difficulty_level_id => level.id, :user_worksheet_attempt => attempt.id, :ques_content =>params[:worksheet][:difficultywise_breakup][level.id.to_s].value)
  end
end

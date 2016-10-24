class StandardsController < ApplicationController
  before_action :find_standard, only: [:get_chapters_list]
  def index
    @standards = Standard.all
  end

  def edit
  end

  def new
    @standard = Standard.new 
  end

  def create
    @standard = Standard.new(standard_params)

    respond_to do |format|
      if @standard.save
        format.html { redirect_to standards_url, notice: 'Standard was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def show
  end

  def get_chapters_list
    @chapters = @subject.chapters
    respond_to do |format|
      format.json {render json: @chapters.pluck(:name, :id).to_json, status: 200}
      format.html
    end
  end

  private
  def standard_params
    params.require(:standard).permit(:name, :standard_number, :board, :code)
  end

  def find_standard
    @standard = Standard.find_by_id(params[:standard_id])
    @subject = @standard.subjects.first
    render nothing: true, status: :not_found unless @standard.present? 
  end

end

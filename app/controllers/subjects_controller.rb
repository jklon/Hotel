class SubjectsController < ApplicationController
  before_action :find_subject, only: [:get_chapters_list]
  def index
    @subjects = Subject.all
  end

  def edit
  end

  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to subjects_url, notice: 'Subject was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def new
    @subject = Subject.new
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
  def subject_params
    params.require(:subject).permit(:name, :description, :full_name, :standard_id, :code)
  end

  def find_subject
    @subject = Subject.find_by_id(params[:subject_id])
    render nothing: true, status: :not_found unless @subject.present? 
  end
end

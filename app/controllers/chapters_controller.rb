class ChaptersController < ApplicationController
  before_action :find_chapter, only: [:get_topics_list]

  def index
    @chapters = Chapter.all
  end

  def edit
    
  end

  def show
  
  end

  def new
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.new(chapter_params)

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to chapters_url, notice: 'Chapter was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def get_topics_list
    @topics = @chapter.topics
    respond_to do |format|
      format.json {render json: @topics.pluck(:name, :id).to_json, status: 200}
      format.html
    end
  end

  private

  def chapter_params
    params.require(:chapter).permit(:name, :chapter_number, :subject_id, :standard_id, :code)
  end

  def find_chapter
    @chapter = Chapter.find_by_id(params[:chapter_id])
    render nothing: true, status: :not_found unless @chapter.present?
  end

end

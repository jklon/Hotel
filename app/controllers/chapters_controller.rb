class ChaptersController < ApplicationController
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

  private
  def chapter_params
    params.require(:standard).permit(:name, :chapter_number, :subject_id, :standard_id, :code)
  end
end

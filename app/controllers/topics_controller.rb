class TopicsController < ApplicationController
  before_filter :set_chapter, only: [:index]

  def index
    if @chapter
      @topics = Topic.where(:chapter =>  @chapter)
    else
      @topics = Topic.all
    end
  end

  private

  def set_chapter
    if params[:chapter_id]
      @chapter = Chapter.find(params[:chapter_id])
    end
  end

end

class SubjectsController < ApplicationController
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

  private
  def subject_params
    params.require(:subject).permit(:name, :description, :full_name, :standard_id, :code)
  end
end

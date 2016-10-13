class StandardsController < ApplicationController
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

  private
  def standard_params
    params.require(:standard).permit(:name, :standard_number, :board)
  end

end

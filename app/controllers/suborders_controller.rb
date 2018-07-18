class SubordersController < ApplicationController
  def new
    @suborder = Suborder.new
  end

  def create
    @suborder = Suborder.new(suborder_params)
    if @suborder.save
      redirect_to root, notice: 'Suborder was created'
    else
      render :new
    end
  end

  private

  def suborder_params
    #params.require(:order).permit(:id)
  end
end

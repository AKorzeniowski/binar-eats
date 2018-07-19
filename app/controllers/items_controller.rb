class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root, notice: 'Item was created'
    else
      render :new
    end
  end

  private

  def item_params
    #params.require(:order).permit(:id)
  end
end

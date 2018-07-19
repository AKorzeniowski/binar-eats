class ItemsController < ApplicationController
  def new
    @item = Item.new
    @order = Order.find_by_id(params[:id])
    if @order == nil
      redirect_to root_path, alert: "Nie istenieje zamówienie o id #{params[:id]}!"
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: 'Item was created'
    else
      render :new
    end
  end

  private

  def item_params
    #params.require(:order).permit(:id)
  end
end

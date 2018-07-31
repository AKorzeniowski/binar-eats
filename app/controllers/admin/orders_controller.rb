class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.all
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to admin_orders_path, notice: 'Order has been deleted.'
  end

  private

  def place_params
    params.require(:place).permit(:name, :menu_url)
  end
end

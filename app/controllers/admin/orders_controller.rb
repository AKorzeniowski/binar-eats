class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.all
  end

  def delete
    @order = Order.find(params[:id])
    @order.destroy
    flash[:notice] = 'Order has been deleted.'
    redirect_to admin_orders_path
  end

  private

  def place_params
    params.require(:place).permit(:name, :menu_url)
  end
end

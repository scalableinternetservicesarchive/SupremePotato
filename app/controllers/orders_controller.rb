class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]

  def index
    filter  = params.permit(:company_id, :user_id)
    @orders = Order.where(filter).includes(:company, :user).order('id DESC').paginate(:page => params[:page], :per_page => 15)
  end

  def new
    order_params = params.permit(:company_id, :user_id)
    @order = Order.new(order_params)
  end

  def create
    ActiveRecord::Base.transaction do
      @order = Order.new(order_params)
      @order.status = Order::PENDING
      @order.save!

      if @order.order_type == Order::BUY
        @order.matches.each do |match|
          Trade.match!(@order, match, match.price)
          break if @order.quantity == 0
        end
      else # Sell Order
        @order.matches.each do |match|
          Trade.match!(match, @order, match.price)
          break if @order.quantity == 0
        end
      end # order-type if/end
    end # transaction

    redirect_to @order, notice: 'Order was successfully created.'
  end

  def destroy
    if @order.status != Order::PENDING
      redirect_to orders_url, notice: 'Cannot cancel a completed order.'
      return
    end

    ActiveRecord::Base.transaction do
      @order.update_attributes(:status => Order::CANCELED)
      @order.user.increment(:balance, @order.quantity * @order.price)
    end

    redirect_to orders_url, notice: 'Order was successfully canceled.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:order_type, :quantity, :price, :company_id, :user_id)
    end
end

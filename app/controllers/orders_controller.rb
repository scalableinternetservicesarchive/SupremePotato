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
    @order = Order.new(order_params)
    @order.status = Order::PENDING
    @order.save!

    match = @order.matches.first

    ActiveRecord::Base.transaction do
      if @order.order_type == Order::BUY
        # Withhold balance
        #use save! here to validate user's balance!
        @order.user.balance -= @order.price
        @order.user.save!

        #match = @order.matches.first
        Trade.match!(@order, match, match.price) if match
      else # Sell Order
        # Check Seller Holding Quantity!
        seller_holding = Holding.where(
          company_id: @order.company_id,
          user_id:    @order.user_id,
        ).first

        if seller_holding.nil? || seller_holding.quantity == 0
          raise 'Invalid Holding Quantity To Create SELL Order.'
        end

        #match = @order.matches.first
        Trade.match!(match, @order, match.price) if match
      end # order-type if/end
    end # transaction

    redirect_to @order, notice: 'Order was successfully created.'
  rescue Exception => ex
    #Rails.logger.info '<<<MANUAL-LOG>>>: ' + ex.message
    @order.errors[:balance] << ex.message
    render :new
  end

  def destroy
    @order.update_attributes(:status => Order::CANCELED)
    redirect_to orders_url, notice: 'Order was successfully canceled.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:order_type, :price, :company_id, :user_id)
    end
end

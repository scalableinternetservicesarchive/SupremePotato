class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]

  def index
    vars = request.query_parameters # Potentially allows us to filter orders based on user_id
    if(vars['user_id'])
      @user_id = vars['user_id']
      @orders = Order.where(user_id: vars['user_id']).includes(:company).includes(:user).paginate(:page => params[:page], :per_page => 15)
    else
      @orders = Order.all.order('id DESC').includes(:company).includes(:user).paginate(:page => params[:page], :per_page => 15)
    end
  end

  def show
    @order = Order.includes(:company).includes(:user).find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    ActiveRecord::Base.transaction do
      @order = Order.new(order_params)
      @order.status = Order::PENDING
      @order.save

      if @order.order_type == Order::BUY
        matching = Order.where(
          company_id: @order.company_id,
          order_type: Order::SELL,
          status:     Order::PENDING
        ).where(
          "price <= ?", @order.price
        ).order(
          'price DESC'
        ).first

        if matching
          trade = Trade.new(
            buy_order:  @order,
            sell_order: matching,
            price:      matching.price,
            company_id: @order.company_id
          )

          # TODO: Be able to purchase / sell more than 1 share at a time
          buyer_holding = Holding.where(
            user_id:    @order.user_id,
            company_id: @order.company_id
          ).first_or_create
          buyer_holding.quantity += 1

          seller_holding = Holding.where(
            user_id:    matching.user_id,
            company_id: matching.company_id,
          ).first
          seller_holding.quantity -= 1

          # Save in DB
          trade.save
          seller_holding.save
          buyer_holding.save
          @order.update_attributes(:status => Order::COMPLETED)
          matching.update_attributes(:status => Order::COMPLETED)
        end
      else
        # Sell Order
        matching = Order.where(
          company_id: @order.company_id,
          order_type: Order::BUY,
          status:     Order::PENDING
        ).where(
          "price >= ?", @order.price
        ).order(
          'price ASC'
        ).first

        if matching
          trade = Trade.new(
            buy_order:  matching,
            sell_order: @order,
            price:      matching.price,
            company_id: @order.company_id
          )

          # TODO: Be able to purchase / sell more than 1 share at a time
          buyer_holding = Holding.where(
            user_id:    matching.user_id,
            company_id: matching.company_id
          ).first_or_create
          buyer_holding.quantity += 1

          seller_holding = Holding.where(
            company_id: @order.company_id,
            user_id:    @order.user_id,
          ).first
          seller_holding.quantity -= 1

          trade.save
          seller_holding.save
          buyer_holding.save
          @order.update_attributes(:status => Order::COMPLETED)
          matching.update_attributes(:status => Order::COMPLETED)
        end # sell order else
      end # order-type if/end
    end # transaction
    redirect_to @order, notice: 'Order was successfully created.'
  rescue Exception => ex
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

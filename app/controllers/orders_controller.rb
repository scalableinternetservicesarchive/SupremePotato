class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    vars = request.query_parameters # Potentially allows us to filter orders based on user_id 
    if(vars['user_id'])
      @user_id = vars['user_id']
      @orders = Order.where(user_id: vars['user_id']).includes(:company).includes(:user).paginate(:page => params[:page], :per_page => 15)
    else
      @orders = Order.all.order('id DESC').includes(:company).includes(:user).paginate(:page => params[:page], :per_page => 15)
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.includes(:company).includes(:user).find(params[:id])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.status = Order::PENDING

    respond_to do |format|
      if @order.save
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
              company_id: @order.company_id,
              user_id: matching.user_id,
            ).first
            seller_holding.quantity -= 1

            if seller_holding.quantity == 0
              seller_holding.destroy
            else
              seller_holding.save
            end

            if trade.save && buyer_holding.save
              @order.update_attributes(:status => Order::COMPLETED)
              matching.update_attributes(:status => Order::COMPLETED)
            end
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
              user_id:    @order.user_id,
              company_id: @order.company_id
            ).first_or_create
            buyer_holding.quantity += 1

            seller_holding = Holding.where(
              company_id: @order.company_id,
              user_id: matching.user_id,
            ).first
            seller_holding.quantity -= 1

            if seller_holding.quantity == 0
              seller_holding.destroy
            else
              seller_holding.save
            end

            if trade.save
              @order.update_attributes(:status => Order::COMPLETED)
              matching.update_attributes(:status => Order::COMPLETED)
            end
          end
        end

        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
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

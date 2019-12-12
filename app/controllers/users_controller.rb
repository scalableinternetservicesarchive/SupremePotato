class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all.order('id DESC').paginate(:page => params[:page], :per_page => 15)
  end

  def show
    @holdings = Holding.where(user_id: params[:id]).includes(:company).order('id DESC')

    # TODO: Watch out for low performance!
    @trades = Trade.joins([:buy_order, :sell_order]).where(
      'orders.user_id = ? OR sell_orders_trades.user_id = ?', params[:id], params[:id]
    ).order('trades.id DESC').paginate(:page => params[:page], :per_page => 15)
    @trades_for_compute = Trade.joins([:buy_order, :sell_order]).where(
      'orders.user_id = ? OR sell_orders_trades.user_id = ?', params[:id], params[:id]
    ).order('trades.id DESC')

    deposits = Deposit.where(user_id: params[:user_id])

    queues = {}
    Company.all.map do |x|
      queues[x.id] = []
    end
    profit = 0
    @profit_history = @trades_for_compute.sort_by(&:created_at).map do |x|
      if x.sell_order.user_id == @user.id
        queue = queues[x.company.id]
        average_cost = 0
        if queue.length > 0
          average_cost = queue.sum{|t| t.price * t.quantity} / queue.sum(&:quantity)
        else 
          average_cost = 0
        end
        queue.shift
        profit += x.price - average_cost
      else
        queues[x.company.id].push(x)
      end
      [x.created_at, profit.round(2)]
    end

    @profit_history = [[@user.created_at, 0]] + @profit_history

  end

  def new
    @user = User.new
  end

  def create
    @user = User.where(name: user_params[:name]).first

    unless @user.nil?
      log_in @user
      redirect_to @user, notice: 'User was successfully created.'
    else
      @user = User.new(user_params)
      @user.balance = 0
      if @user.save
        Rails.cache.write('user_name_' + @user.id.to_s, @user.name)
        log_in @user
        redirect_to @user, notice: 'User was successfully created2.'
      else
        render :new
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name)
    end
end

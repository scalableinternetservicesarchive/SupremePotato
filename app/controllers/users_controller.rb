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
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.balance = 0
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
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

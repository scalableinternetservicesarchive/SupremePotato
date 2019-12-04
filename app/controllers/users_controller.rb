class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all.order(:name).paginate(:page => params[:page], :per_page => 15)
  end

  def show
    @holdings = @user.holdings.includes(:company)
    @trades   = @user.trades.order('id DESC').paginate(:page => params[:page], :per_page => 15)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.where(name: user_params[:name]).first

    unless @user.nil?
      redirect_to @user, notice: 'User was successfully created.'
    else
      @user = User.new(user_params)
      @user.balance = 0
      if @user.save
        Rails.cache.write("user_name_#{@user.id}", @user.name)
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

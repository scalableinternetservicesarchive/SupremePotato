class DepositsController < ApplicationController
  def index
    @user     = User.find(params[:user_id])
    @deposits = @user.deposits.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @deposit = Deposit.new
  end

  def create
    @deposit = Deposit.new(deposit_params)
    @deposit.user_id = params[:user_id] # set user_id since can't be provided
    @deposit.user.balance += @deposit.amount
    if @deposit.save && @deposit.user.save
      redirect_to @deposit.user, notice: 'Transfer was successful!' and return
    end
    render :new
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def deposit_params
      params.require(:deposit).permit(:amount)
    end
end

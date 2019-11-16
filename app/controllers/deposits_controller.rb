class DepositsController < ApplicationController
  def index
    @deposits = Deposit.where(user_id: params[:user_id])
  end

  def new
    @deposit = Deposit.new
  end

  def create
    @deposit = Deposit.new(deposit_params)
    @deposit.user_id = params[:user_id] # set user_id since can't be provided
    if @deposit.valid?
      @deposit.user.balance += @deposit.amount
      if @deposit.user.save && @deposit.save
        redirect_to @deposit.user, notice: 'Transfer was successful!' and return
      end
    end
    render :new
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def deposit_params
      params.require(:deposit).permit(:amount)
    end
end

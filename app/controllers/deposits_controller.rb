class DepositsController < ApplicationController
  def index
    @errors = []
  end

  def deposit
    # TODO: Form validation (empty params, string value for amount, etc)
    @errors = []
    @user = User.where(:name => params[:user_name]).first
    if @user.nil?
      @errors.push "User name not found."
    else
      new_balance = @user.balance
      amount = params[:amount].to_i
      if params[:from] == 'Your Bank' && params[:to] == 'Trading Account'
        new_balance += amount
      elsif params[:from] == 'Trading Account' && params[:to] == 'Your Bank'
        if @user.balance >= amount
          new_balance -= amount
        else
          @errors.push "Can't withdraw more than account balance."
        end
      else
        @errors.push 'Invalid to/from account.'
      end
    end

    respond_to do |format|
      if @errors.empty?
        if @user.update(:balance => new_balance)
          format.html { redirect_to @user, notice: 'Transfer was successful!' }
          format.json { render :show, status: :created, location: @user }
        else
          @errors.push "Failed to save record."
        end
      end

      if @errors.any?
        format.html { render :index}
        format.json { render json: @errors, status: :unprocessable_entity }
      end
    end
  end
end

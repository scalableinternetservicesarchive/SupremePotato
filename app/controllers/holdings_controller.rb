class HoldingsController < ApplicationController

  # GET /holdings
  # GET /holdings.json
  def index
    if params[:user_id].nil?
      @holdings = Holding.all.includes(:company)
    else
      @holdings = Holding.where(user_id: params[:user_id]).includes(:company)
    end
  end
end

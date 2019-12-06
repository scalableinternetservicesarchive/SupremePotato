class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
    @trades  = @company.trades.order('id DESC').paginate(:page => params[:page], :per_page => 20)
  end
end

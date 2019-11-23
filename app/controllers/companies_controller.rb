class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.includes(:trades)
  end

  def show
    @trades = Trade.where(company_id: params[:id])
                .order('id DESC')
                .paginate(:page => params[:page], :per_page => 20)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end
end

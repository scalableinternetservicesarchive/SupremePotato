class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.includes(:trades)
  end

  # GET /companies/1
  def show
    @trades = Trade.where(
            company_id: params[:id],
          ).order('updated_at DESC')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end
end

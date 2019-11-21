class CurveController < ApplicationController
  def index
  	@companies = Company.includes(:trades)
  end
end

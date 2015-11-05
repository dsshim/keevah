class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @loan_requests = LoanRequest.joins(:categories).where(categories: {id: @category.id}).paginate(:page => params[:page], :per_page => 15)
  end
end

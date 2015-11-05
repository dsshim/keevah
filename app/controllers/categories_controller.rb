class CategoriesController < ApplicationController
  def index
    @categories = Category.cached_categories
  end

  def show
    @category = Category.find(params[:id])
    # @loan_requests = LoanRequest.cached_single_category(@category.id).paginate(:page => params[:page], :per_page => 15)
    @loan_requests = LoanRequest.joins(:categories).where(categories: {id: @category.id}).paginate(:page => params[:page], :per_page => 15)

  end
end

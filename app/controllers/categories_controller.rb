class CategoriesController < ApplicationController
  def index
    # @categories = Category.cached_categories
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    # total_lrs = LoanRequest.joins(:categories).where(categories: {id: @category.id}).count
    # @loan_requests = LoanRequest.cached_single_category(@category.id).paginate(:page => params[:page], :per_page => 15)
    @loan_requests = LoanRequest.joins(:categories).where(categories: {id: @category.id}).paginate(page: params[:page], per_page: 15)

  end

  # private
  # def total_lrs
  #   Rails.cache.fetch("total_loan_req_by_cat_count") do
  #     # all.inject(0) {|total, a| total += a.word_count }
  #   LoanRequest.joins(:categories).where(categories: {id: @category.id}).count
  #   end
  # end
end

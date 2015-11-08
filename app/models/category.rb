class Category < ActiveRecord::Base
  
  validates :title, :description, presence: true
  validates :title, uniqueness: true
  has_many :loan_requests_categories
  has_many :loan_requests, through: :loan_requests_categories

  def self.cached_categories
    Rails.cache.fetch("all_categories") do
      Category.all
    end
  end

  def self.total_loan_req_count_by_cat
    Rails.cache.fetch("all_categories") do
      Category.all
    end
  end


end

class LendersController < ApplicationController
  before_action :set_lender, only: [:show]
  before_action :set_projects, only: [:show]

  def new
    @user = User.new
  end

  def create
    user = User.new(lender_params.merge(role: "lender"))
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "You've been saved"
      redirect_to lender_path(user)
    else
      errors = user.errors.full_messages
      errors.shift if errors.include?("Password confirmation doesn't match Password")
      flash[:error] = errors.to_sentence
      redirect_to root_path
    end
  end

  def show
    unless current_lender?
      redirect_to root_path, notice: "Access denied"
    end
  end

  private

  def lender_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_lender
    @lender = User.find(params[:id])

  end

  def set_projects
    @projects = User.joins(:loan_requests).where(loan_requests: {user_id: params[:id]})
  end

  def current_lender?
    current_user && current_user.id == params[:id].to_i
  end

  helper_method :current_lender?
end

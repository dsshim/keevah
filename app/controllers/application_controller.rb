class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :create_cart

  # unless Rails.application.config.consider_all_requests_local
  #   rescue_from ActiveRecord::RecordNotFound,
  #               ActionController::RoutingError,
  #               ActionController::UnknownController,
  #               # ActionController::UnknownAction,
  #               ActionController::MethodNotAllowed do |exception|
  #
  #
  # 
  #     redirect_to "/500"
  #   end
  # end


  def create_cart
    @current_cart = Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_borrower?
    current_user && current_user.borrower?
  end



  helper_method :create_cart, :current_user, :current_borrower?
end

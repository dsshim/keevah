module CartHelper
  def find_users
    User.joins(:loan_requests)
      .where(loan_requests: {id: @current_cart.cart_items.keys})
  end

  def find_amounts
    @current_cart.cart_items.values
  end
end

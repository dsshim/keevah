unless Rails.env.production? # ~> NameError: uninitialized constant Rails
  require 'capybara/poltergeist'


  desc "Simulate load against Blogger application"
  task :load_test => :environment do

    # 1.times.map { Thread.new { browse } }.map(&:join)
    loop do
      anonymous_user_browses_lenders
      anonymous_user_browses_pages_of_lenders
      anonymous_user_browses_individual_loan_request
      user_browses_loan_requests
      user_browses_individual_loan_requests
      new_user_can_sign_up_as_lender
      new_user_can_sign_up_as_borrower
      new_user_create_a_loan_request
      new_user_funds_a_loan
      
    end

  end

  def browse
    # loop do
    #   anonymous_user_browses_lenders
    #   anonymous_user_browses_lenders_on_multiple_pages
    #   # browse_articles_with_comments
    #   # browse_most_popular_article
    #   # leave_comments
    # end
  end

  def anonymous_user_browses_lenders
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/browse")
    session.click_link("Lend")

    puts "browses all lenders"

  end

  def anonymous_user_browses_pages_of_lenders
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/browse")

    session.all("div.pagination a").sample.click
    puts "browses all lenders on multiple pages"

  end

  def anonymous_user_browses_individual_loan_request
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/browse")
    session.all("a", text: "About").sample.click
    puts "browses individual loan request"

  end

  def user_browses_loan_requests
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/")

    session.click_link("Login")
    session.fill_in "Email", with: "test@test.com"
    session.fill_in "Password", with: "password"
    session.click_button("Log In")
    session.click_link("Lend")
    sleep 2
    session.all("div.pagination a").sample.click
    puts "user browses loan requests"
  end

  def user_browses_individual_loan_requests
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/")

    session.click_link("Login")
    session.fill_in "Email", with: "test@test.com"
    session.fill_in "Password", with: "password"
    session.click_button("Log In")
    session.click_link("Lend")
    sleep 2
    session.all("div.pagination a").sample.click
    session.all("a", text: "About").sample.click
    puts "user browses individual loan requests"
  end

  def new_user_can_sign_up_as_lender
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/")
    session.all("a", text: "Sign Up").first.click
    session.click_link("Sign Up As Lender")
    session.fill_in "Name", with: "test"
    session.fill_in "Email", with: "test@test#{rand(1..10000)}.com"
    session.fill_in "Password", with: "password"
    session.fill_in "Confirm Password", with: "password"
    session.click_button "Create Account"
    session.click_link("Portfolio")
    puts "new user can sign up as a lender"
  end

  def new_user_can_sign_up_as_borrower
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/")
    session.all("a", text: "Sign Up").first.click
    session.click_link("Sign Up As Borrower")
    session.fill_in "Name", with: "test"
    session.fill_in "Email", with: "test@test#{rand(1..10000)}.com"
    session.fill_in "Password", with: "password"
    session.fill_in "Confirm Password", with: "password"
    session.click_button "Create Account"
    session.click_link("Create Loan Request")
    puts "new user can sign up as a borrower"
  end

  def new_user_create_a_loan_request
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/")
    session.all("a", text: "Sign Up").first.click
    session.click_link("Sign Up As Borrower")
    session.fill_in "Name", with: "test"
    session.fill_in "Email", with: "test@test#{rand(1..10000)}.com"
    session.fill_in "Password", with: "password"
    session.fill_in "Confirm Password", with: "password"
    session.click_button "Create Account"
    session.click_link("Create Loan Request")
    session.fill_in "Title", with: "New Loan"
    session.fill_in "Description", with: "Give me money"
    session.fill_in "Image url", with: ""
    session.fill_in "Requested by date", with: '2015/10/01'
    session.fill_in "Repayment begin date", with: '2015/12/01'
    session.select 'Monthly', from: "Repayment rate"
    session.select 'Agriculture', from: "Category"
    session.fill_in "Amount", with: 10000
    session.click_button "Submit"
    session.all("a", text: "Details").first.click

    puts "new user creates loan request"
  end

  def new_user_funds_a_loan
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://scale-up-performance.herokuapp.com/")
    session.all("a", text: "Sign Up").first.click
    session.click_link("Sign Up As Lender")
    session.fill_in "Name", with: "test"
    session.fill_in "Email", with: "test@test#{rand(1..10000)}.com"
    session.fill_in "Password", with: "password"
    session.fill_in "Confirm Password", with: "password"
    session.click_button "Create Account"

    session.click_link("Lend")
    sleep 2
    session.all("div.pagination a").sample.click
    session.all("a", text: "Contribute #$25").sample.click
    session.click_link("Basket")
    session.click_on("Transfer Funds")


    puts "new user funds a loan"
  end
end

# ~> NameError
# ~> uninitialized constant Rails
# ~>
# ~> /Users/Dave/turing/module_4/keevah/lib/tasks/load_test.rake:1:in `<main>'

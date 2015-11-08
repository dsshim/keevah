require "logger"
require "pry"
require "capybara"
require 'capybara/poltergeist'
require "faker"
require "active_support"
require "active_support/core_ext"

module LoadScript
  class Session
    include Capybara::DSL
    attr_reader :host
    def initialize(host = nil)

      Capybara.default_driver = :poltergeist
      @host = host || "http://localhost:3000"
    end

    def logger
      @logger ||= Logger.new("./log/requests.log")
    end

    def session
      @session ||= Capybara::Session.new(:poltergeist)
    end

    def run
      while true
        begin
        run_action(actions.sample)
        rescue
        puts "heroku error"
        retry while true
      end
    end
  end

    def run_action(name)
      benchmarked(name) do
        send(name)
      end
    rescue Capybara::Poltergeist::TimeoutError
      logger.error("Timed out executing Action: #{name}. Will continue.")
    end

    def benchmarked(name)
      logger.info "Running action #{name}"
      start = Time.now
      val = yield
      logger.info "Completed #{name} in #{Time.now - start} seconds"
      val
    end

    def actions
      [:browse_loan_requests, :sign_up_as_lender, :anonymous_user_browses_pages_of_lenders, :user_browses_loan_requests, :user_browses_individual_loan_requests, :sign_up_as_borrower, :new_user_create_a_loan_request, :new_user_funds_a_loan, :user_can_browse_all_categories, :user_can_browse_individual_categories]
    end

    def log_in(email="demo+horace@jumpstartlab.com", pw="password")
      log_out
      session.visit host
      session.click_link("Login")
      session.fill_in("Email", with: email)
      session.fill_in("Password", with: pw)
      session.click_link_or_button("Log In")
    end

    def browse_loan_requests
      session.visit "#{host}/browse"
      session.all(".lr-about").sample.click
      puts "browse loan requests"
    end

    def log_out
      session.visit host
      if session.has_content?("Log out")
        session.find("#logout").click
      end
    end

    def new_user_name
      "#{Faker::Name.name} #{Time.now.to_i} #{rand(1..1000)}"
    end

    def new_user_email(name)
      "TuringPivotBots+#{name.split.join}@gmail.com"
    end

    def sign_up_as_lender(name = new_user_name)
      log_out
      session.find("#sign-up-dropdown").click
      session.find("#sign-up-as-lender").click
      session.within("#lenderSignUpModal") do
        session.fill_in("user_name", with: name)
        session.fill_in("user_email", with: new_user_email(name))
        session.fill_in("user_password", with: "password")
        session.fill_in("user_password_confirmation", with: "password")
        session.click_link_or_button "Create Account"
        puts "sign up as lender"
      end
    end

    def sign_up_as_borrower(name = new_user_name)
      log_out
      session.find("#sign-up-dropdown").click
      session.find("#sign-up-as-borrower").click
      session.within("#borrowerSignUpModal") do
        session.fill_in("user_name", with: name)
        session.fill_in("user_email", with: new_user_email(name))
        session.fill_in("user_password", with: "password")
        session.fill_in("user_password_confirmation", with: "password")
        session.click_link_or_button "Create Account"
        puts "sign up as borrower"
      end
    end


    def categories
      ["Agriculture", "Education", "Community"]
    end

    def anonymous_user_browses_pages_of_lenders

      session.visit("#{host}/browse")

      session.all("div.pagination a").sample.click
      puts "browses all lenders on multiple pages"

    end

    def anonymous_user_browses_individual_loan_request

      session.visit("#{host}/browse")
      session.all("a", text: "About").sample.click
      puts "browses individual loan request"

    end

    def user_browses_loan_requests
      log_in
      session.visit "#{host}/browse"

      session.all("div.pagination a").sample.click
      puts "user browses loan requests"
    end

    def user_browses_individual_loan_requests


      log_in

      session.visit "#{host}/browse"

      session.all("div.pagination a").sample.click
      session.all("a", text: "About").sample.click
      puts "user browses individual loan requests"
    end

    def new_user_create_a_loan_request
      sign_up_as_borrower
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

      puts "new user creates loan request"
    end

    def new_user_funds_a_loan
      sign_up_as_lender
      session.visit "#{host}/browse"
      session.all("div.pagination a").sample.click
      session.all("a", text: "Contribute #$25").sample.click
      session.click_link("Basket")
      session.click_on("Transfer Funds")
      log_out

      puts "new user funds a loan"
    end

    def user_can_browse_all_categories
      log_in
      session.visit "#{host}/categories"
      puts "user can browse all categories"
    end

    def user_can_browse_individual_categories
      log_in
      session.visit "#{host}/categories/#{rand(1..15)}"
      session.all(".lr-about").sample.click
      puts "user can browse individual categories"

    end
  end
end

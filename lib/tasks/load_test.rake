unless Rails.env.production? # ~> NameError: uninitialized constant Rails
  require 'capybara/poltergeist'


  desc "Simulate load against Blogger application"
  task :load_test => :environment do

    # 2.times.map { Thread.new { browse } }.map(&:join)

    browse
  end

  def browse
    loop do
      anonymous_user_browses_lenders
      # browse_articles_with_comments
      # browse_most_popular_article
      # leave_comments
    end
  end

  def anonymous_user_browses_lenders
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://whispering-castle-6748.herokuapp.com/")
    session.click_link("Lend")
    session.all("p.lr-about a").sample.click
    puts "browses all lenders"

  end

  def browse_articles_with_comments
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://whispering-castle-6748.herokuapp.com/")
    session.all("li.comment a").sample.click
    puts "browse article w/comments"

  end

  def browse_most_popular_article
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://whispering-castle-6748.herokuapp.com/")
    session.all("li#most_popular a").first.click
    puts "pop article"

  end

  def leave_comments
    session = Capybara::Session.new(:poltergeist)

    session.visit("https://whispering-castle-6748.herokuapp.com/")
    session.all("li.article a").sample.click
    session.fill_in("Author name", with: "Dave")
    session.fill_in("Body", with:"Comment")
    session.click_button("Save")
    puts "leave comments"


  end
end

# ~> NameError
# ~> uninitialized constant Rails
# ~>
# ~> /Users/Dave/turing/module_4/keevah/lib/tasks/load_test.rake:1:in `<main>'

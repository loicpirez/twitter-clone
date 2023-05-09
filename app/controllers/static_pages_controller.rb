# frozen_string_literal: true

# This is a controller for serving static pages in a Ruby on Rails application.
# StaticPagesController handles requests for several static pages, including a
# home page that displays a user's feed, a contact page, a help page,
# and an about page.
# The home action also creates a new Micropost object for the current user and
# retrieves their feed items to display on the page.
# This controller does not require a user to be logged in to access the
# contact, help, or about pages, but does require a user to be logged in to
# access the home page.
class StaticPagesController < ApplicationController
  def contact; end

  def home
    return unless logged_in?

    @micropost = current_user.microposts.build if logged_in?
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help; end

  def about; end
end

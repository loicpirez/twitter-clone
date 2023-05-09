# frozen_string_literal: true

# ApplicationController is the parent controller for all controllers in the
# Rails application.
# It includes the SessionsHelper module and defines the `logged_in_user` method,
# which checks if a user is logged in and redirects them to the login page if
# they are not.
class ApplicationController < ActionController::Base
  include SessionsHelper
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
end

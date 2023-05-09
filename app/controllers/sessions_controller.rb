# frozen_string_literal: true

# Controller responsible for managing user login sessions.
# It provides functionality for creating, destroying, and validating user sessions.
# This controller handles the login process, checks if the
# user account is activated, and sets up the appropriate session information
# for the user. It also provides functionality for logging out of the system.
class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_by_email

    if valid_user?(user)
      if user.activated?
        log_in user
        remember_or_forget(user)
        redirect_back_or user
      else
        message = 'Account not activated.'
        message += 'Please check your email for activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      handle_invalid_credentials
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def find_user_by_email
    User.find_by(email: params[:session][:email])
  end

  def valid_user?(user)
    user&.authenticate(params[:session][:password])
  end

  def remember_or_forget(user)
    if params[:session][:remember_me] == '1'
      remember(user)
    else
      forget(user)
    end
  end

  def handle_invalid_credentials
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new', status: :unprocessable_entity
  end
end

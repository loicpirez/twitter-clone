# frozen_string_literal: true

# The `SessionsHelper` module is responsible for handling user sessions.
# It includes methods for logging in and out users,
# remembering them in a persistent session,
# checking if a user is currently logged in,
# and redirecting users back to their original requested page after logging in.
# It also includes methods for storing the current page URL in a session variable,
# so that users can be redirected back to it after logging in,
# and forgetting a persistent session.
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    # cookies[:user_id] = {value: user.id, expires: 20.years.from_now.utc}
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])

      # TODO: Fix offense!
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    user = current_user
    forget(user)
    reset_session
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end

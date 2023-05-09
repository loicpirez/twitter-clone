# frozen_string_literal: true

# This controller handles the activation of user accounts. When a user clicks
# on an activation link in their email, they are directed to the edit action of
# this controller where their account is activated if the activation link is
# valid. If the link is invalid, they are redirected to the root URL with an
# error message.
class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])

    if user && !user.activated? && user.authenticated?(:activation,
                                                       params[:id])
      user.activate
      flash[:success] = 'Account successfully activated!'
      log_in user
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end

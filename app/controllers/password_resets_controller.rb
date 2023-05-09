# frozen_string_literal: true

# PasswordResetsController is responsible for handling password reset requests
# from users who have forgotten their passwords.
# It includes `before_action` callbacks to get and validate the user based on
# their email and reset token.
# The `create` action initiates the password reset process by creating a reset
# digest and sending a password reset email to the user's email address.
# The `edit` action renders the password reset form.
# The `update` action updates the user's password, logs them in, and redirects
# to their profile page if successful.
# If the password reset has expired or the password field is empty, the user
# will be redirected to the password reset form with an error message.
class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]

  def create
    @user = User.find_by(email: params[:password_reset][:email])

    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset has expired.'
      redirect_to password_resets_path
    elsif params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :password, :password_confirmation
    )
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    unless @user&.activated? &&
           @user&.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
end

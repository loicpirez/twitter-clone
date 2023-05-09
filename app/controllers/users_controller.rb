# frozen_string_literal: true

# The `UsersController` class is a controller that manages user-related actions,
# such as displaying user profiles, creating  new users, updating user
# information, and deleting user accounts. It defines
# a set of public methods that correspond to HTTP requests, such as index, show,
# create, update, destroy, following, and followers.
# The controller also defines a set of private methods that are used as
# filters to ensure that certain actions can only be performed by logged-in users,
# correct users, or admin users. For example, the before_action method is used to
# call logged_in_user before any of the actions that require the user to be logged
# in, and correct_user before any of the actions that require the user to be the
# correct user for the action.
# The controller interacts with the User model to retrieve and manipulate user
# data, such as finding users, creating new users, and updating user profiles.
# It also uses pagination to limit the number of results displayed on each page.
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy following
                                          followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: %i[destroy]
  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
      #      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url, status: :see_other
  end

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end

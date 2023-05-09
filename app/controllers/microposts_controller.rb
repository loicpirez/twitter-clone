# frozen_string_literal: true

# MicropostsController is responsible for handling CRUD operations on Microposts,
# a model that represents short posts created by users.
# It inherits from the ApplicationController class and includes the `before_action`
# callbacks to ensure that only logged-in users can create or delete microposts.
# The `create` action creates a new micropost belonging to the current user and
# saves it to the database. If successful, it redirects to the home page and
# displays a success message. If not, it renders the home page with the
# unprocessable entity status code.
# The `destroy` action deletes a micropost only if the current user is the
# owner of the post, and redirects to the previous page
# or the home page if successful.
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referer || root_url, status: :see_other
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to(root_url, status: :see_other) if @micropost.nil?
  end
end

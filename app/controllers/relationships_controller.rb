# frozen_string_literal: true

# Controller for managing user relationships, i.e. following and unfollowing users.
# Requires user to be logged in to create or destroy relationships.
class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_to @user, status: :see_other }
      format.turbo_stream
    end
  end
end

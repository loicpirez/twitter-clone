# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
    @user = users(:user)
    @other_user = users(:other_user)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
    assert_select 'title', "Sign up | #{@base_title}"
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged it' do
    get edit_user_path @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged it' do
    patch user_path @user, params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as @other_user
    get edit_user_path(@user)
    assert_empty flash
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as @other_user
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert_empty flash
    assert_redirected_to root_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as @other_user
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email,
      admin: true
    } }
    assert_not @other_user.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path @user
      assert_redirected_to login_url
    end
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as @other_user

    assert_no_difference 'User.count' do
      delete user_path @user
      assert_redirected_to root_url
    end
  end

  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end

# frozen_string_literal: true

require 'test_helper'

class UserSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UserSignup
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: '',
          email: 'user@invalid',
          password: 'foo',
          password_confirmation: 'bar'
        }
      }
    end
    assert_template 'users/new'
    assert_select '#error_explanation'
    assert_select '.field_with_errors'
  end

  test 'valid signup information with account activation' do
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'Example User',
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.length
  end
end

class AccountActivationTest < UserSignup
  def setup
    super
    post users_path, params: {
      user: {
        name: 'Example User',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }
    @user = assigns(:user)
  end

  test 'should not be activated' do
    assert_not @user.activated
  end

  test 'should not be able to log in before account activation' do
    log_in_as @user
    assert_not logged_in?
  end

  test 'should not be able to log in with invalid activation token' do
    get edit_account_activation_path('invalid_token', email: @user.email)
    assert_not logged_in?
  end

  test 'should not be able to log in with invalid activation email' do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not logged_in?
  end

  test 'should be able to log in with valid activation token and email' do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
  end
end

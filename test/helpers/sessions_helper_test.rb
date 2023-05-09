# frozen_string_literal: true

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:user)
    remember(@user)
  end

  test 'current_user returns right user when session is nil' do
    assert_equal @user, current_user
    assert logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @user.assign_attributes(remember_digest: User.digest(User.new_token))
    @user.save(validate: true)
    assert_nil current_user
  end
end

# frozen_string_literal: true

require 'test_helper'

# Micropost test
class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:user)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
    # @micropost = microposts(:micropost)
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  test 'content should be at most 140 characters' do
    @micropost.content = '.' * 141
    assert_not @micropost.valid?
  end

  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end

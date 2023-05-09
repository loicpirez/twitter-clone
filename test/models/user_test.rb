# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Example User',
      email: 'user@example.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '  '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '  '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'x' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = "#{'x' * 256}@example.com"
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM
                         A_US-er@foo.bar.org first.last@foo.jp
                         alice+boo@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[
      user@example,com user_at_foo.org
      user.anem@example. foo@bar_bz.com foo@bar+baz.com
    ]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email should downcase' do
    mixed_case_email = 'TeSt@PiReZ.Fr'

    @user.email = mixed_case_email
    @user.save
    assert_equal @user.email, mixed_case_email.downcase
  end

  test 'password should have a minimum length' do
    @user.password, @user.password_confirmation = 'x' * 5
    assert_not @user.valid?
  end

  test 'password should have a maximum length' do
    @user.password, @user.password_confirmation = 'x' * 51
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(
      content: 'Hello world!'
    )
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    user = users(:user)
    archer = users(:archer)

    assert_not user.following?(archer)
    user.follow(archer)
    assert user.following?(archer)
    assert_includes archer.followers, user
    user.unfollow(archer)
    assert_not user.following?(archer)
  end

  test 'feed should have the right posts' do
    user = users(:user)
    archer = users(:archer)
    lana = users(:lana)

    # Posts from followed user
    lana.microposts.each do |post_following|
      assert_includes user.feed, post_following
    end
    # Post from self
    user.microposts.each do |post_self|
      assert_includes user.feed, post_self
    end

    archer.microposts.each do |post_unfollowed|
      assert_not user.feed.include?(post_unfollowed)
    end
  end
end

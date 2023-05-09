# frozen_string_literal: true

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user)
    @other_user = users(:other_user)
  end

  test 'index as admin including pagination amd delete links' do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_user = User.paginate(page: 1)

    first_page_of_user.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'Delete', method:
          'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test 'index as non_admin' do
    log_in_as @other_user
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end
end

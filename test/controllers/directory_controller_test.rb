require 'test_helper'

class DirectoryControllerTest < ActionController::TestCase
  test 'should get directory index if logged in' do
    get :show, {}, current_user_id: employees(:consultant).id
    assert_response :success
  end

  test 'should not get directory index if not logged in' do
    get :show
    assert_redirected_to :login
  end
end

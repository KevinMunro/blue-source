require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  test 'can get standard calendar' do
    get :index, nil, current_user_id: employees(:consultant).id
    assert_response :success
  end

  test 'can get standard report' do
    test_vacation = vacations(:three)
    test_filter = { start_date: '2013-12-23', end_date: '2013-12-23', vacation: '1', include_pending: '0' }
    assert_not_equal 0, Vacation.where(start_date: test_vacation.start_date, end_date: test_vacation.end_date)
    get :report, { filter: test_filter }, current_user_id: employees(:consultant).id
    assert_equal @controller.instance_variable_get(:@vacations).count, 1
    assert_nil flash[:error]
    assert_response :success
  end

  test 'start date must be less than end date' do
    test_filter = { start_date: Time.now + 1.day, end_date: Time.now, vacation: '1' }
    get :report, { filter: test_filter }, current_user_id: employees(:consultant).id
    assert_not_nil flash[:error]
    assert_response :redirect
  end
end

require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  test 'should get edit if manager of user' do
    patch :update, { id: employees(:consultant).id, employee: { first_name: 'test' } },  current_user_id: employees(:manager).id
    assert_redirected_to employees(:consultant)
  end

  test "should not be able to edit consultant if not consultant's manager" do
    patch :update, { id: employees(:consultant).id },  current_user_id: employees(:manager2).id
    assert_redirected_to :root
  end

  test 'consultant should not get edit and should be redirected to sorry' do
    patch :update, { id: employees(:consultant).id },  current_user_id: employees(:consultant).id
    assert_redirected_to view_employee_vacations_path(employees(:consultant))
  end

  test 'consultant should not be able to edit other consultant and should be redirected to sorry' do
    patch :update, { id: employees(:consultant2).id },  current_user_id: employees(:consultant).id
    assert_redirected_to view_employee_vacations_path(employees(:consultant))
  end

  test 'should be able to view consultant if manager' do
    get :show, { id: employees(:consultant).id },  current_user_id: employees(:manager).id
    assert_response :success
  end

  test "should not be able to view consultant if not consultant's manager" do
    get :show, { id: employees(:consultant).id }, current_user_id: employees(:manager2).id
    assert_redirected_to :root
  end

  test 'consultant should not be able to view consultant' do
    get :show, { id: employees(:consultant).id }, current_user_id: employees(:consultant).id
    assert_redirected_to view_employee_vacations_path(employees(:consultant))
  end

  test 'consultant should not be able to view other consultant' do
    get :show, { id: employees(:consultant2).id }, current_user_id: employees(:consultant).id
    assert_redirected_to view_employee_vacations_path(employees(:consultant))
  end

  test 'should redirect to vacations if consultant' do
    get :index, nil, current_user_id: employees(:consultant).id
    assert_redirected_to view_employee_vacations_path(employees(:consultant))
  end

  test 'should get index if manager' do
    get :index, nil, current_user_id: employees(:manager).id
    assert !employees(:manager).subordinates.empty?
    assert_response :success
  end

  test 'manager should not be able to create new employee' do
    employee = employees(:consultant)
    post :create, { employee: { username: employee.username,
                                first_name: employee.first_name,
                                last_name: employee.last_name,
                                email: employee.email,
                                role: employee.role,
                                department: employee.department,
                                status: employee.status },
                    id: employees(:consultant).id },  current_user_id: employees(:manager).id
    assert_redirected_to :root
    assert_not_nil flash[:error]
  end

  test 'admin should be able to create new employee' do
    post :create, { employee: { username: 'michael.jordan',
                                first_name: 'Michael',
                                last_name: 'Jordan',
                                email: 'michael.jordon@orasi.com',
                                role: 'Base',
                                department: 'rural',
                                status: 'Permanent',
                                start_date: '2014-08-05' } },
         current_user_id: employees(:company_admin).id
    assert_redirected_to :root
    assert_not_nil flash[:success]
  end

  test 'admin cannot create employee duplicate employee' do
    employee = employees(:consultant)
    post :create, { employee: { username: employee.username,
                                first_name: employee.first_name,
                                last_name: employee.last_name,
                                email: employee.email,
                                role: employee.role,
                                department: employee.department,
                                status: employee.status,
                                start_date: employee.start_date } },
         current_user_id: employees(:company_admin).id
    assert_not_nil flash[:error]
  end

  test 'admin should not be able to create new employee with invalid start date' do
    request.env['HTTP_REFERER'] = root_path
    post :create, { employee: { username: 'michael.jordan',
                                first_name: 'Michael',
                                last_name: 'Jordan',
                                email: 'michael.jordon@orasi.com',
                                role: 'Base',
                                department: 'rural',
                                status: 'Permanent',
                                start_date: 'afefiauhfeliafuh' } },
         current_user_id: employees(:company_admin).id
    assert_redirected_to :root
    assert_not_nil flash[:error]
  end

  test 'no current user and no referer is redirected to login' do
    get :index
    assert_redirected_to :login
  end

  test 'user can set resourcesPerPage if logged in' do
    consultant = employees(:consultant)
    assert_not_equal '10', consultant.preferences[:resourcesPerPage]
    patch :preferences, { employee_id: consultant.id, employee: { preferences: { resourcesPerPage: 10 } } }, current_user_id: consultant.id
    consultant.reload
    assert_equal '10', consultant.preferences[:resourcesPerPage]
    assert_nil flash[:error]
  end

  test 'user cannot set resourcesPerPage if not logged in' do
    consultant = employees(:consultant)
    assert_not_equal '10', consultant.preferences[:resourcesPerPage]
    patch :preferences, { employee_id: consultant.id, employee: { preferences: { resourcesPerPage: 10 } } }
    consultant.reload
    assert_not_equal '10', consultant.preferences[:resourcesPerPage]
    assert_redirected_to :login
  end

  test 'other user cannot set resourcesPerPage if logged in' do
    consultant = employees(:consultant)
    manager = employees(:manager)
    assert_not_equal '10', consultant.preferences[:resourcesPerPage]
    patch :preferences, { employee_id: consultant.id, employee: { preferences: { resourcesPerPage: 10 } } }, current_user_id: manager.id
    consultant.reload
    assert_not_equal '10', consultant.preferences[:resourcesPerPage]
    assert_not_nil flash[:error]
  end

  test 'user cannot set resourcesPerPage to less than 0 if logged in' do
    consultant = employees(:consultant)
    patch :preferences, { employee_id: consultant.id, employee: { preferences: { resourcesPerPage: -1 } } }, current_user_id: consultant.id
    consultant.reload
    assert_not_equal '-1', consultant.preferences[:resourcesPerPage]
    assert_not_nil flash[:error]
  end
end

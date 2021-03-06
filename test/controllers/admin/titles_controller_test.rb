require 'test_helper'

module Admin
  class TitlesControllerTest < ActionController::TestCase
    setup do
      @title = titles(:consultant)
      @manager_title = titles(:manager)
      @invalid_admin_types = %i(inactive_sys_admin contractor_sys_admin)
    end

    test 'should get index' do
      get :index, nil, current_user_id: employees(:sys_admin).id
      assert_response :success
      assert_not_nil assigns(:titles)
    end

    test 'should get new' do
      get :new, nil, current_user_id: employees(:sys_admin).id
      assert_response :success
    end

    test 'should create title' do
      assert_difference('Title.count') do
        post :create, { title: { name: "#{@title.name} testing" } }, current_user_id: employees(:sys_admin).id
      end

      assert_redirected_to admin_titles_path
    end

    test 'should get edit' do
      get :edit, { id: @title }, current_user_id: employees(:sys_admin).id
      assert_response :success
    end

    test 'should update title' do
      patch :update, { id: @title, title: { name: @title.name } }, current_user_id: employees(:sys_admin).id
      assert_redirected_to admin_titles_path(assigns(:title))
    end

    test 'should destroy title' do
      assert_difference('Title.count', -1) do
        delete :destroy, { id: @title }, current_user_id: employees(:sys_admin).id
      end

      assert_redirected_to admin_titles_path
    end

    test 'should not get new' do
      @invalid_admin_types.each do |admin_type|
        get :new, nil, current_user_id: employees(admin_type).id
        assert_response :redirect
      end
    end

    test 'should not create title' do
      @invalid_admin_types.each do |admin_type|
        assert_no_difference('Title.count') do
          post :create, { title: { name: "#{@title.name} testing" } }, current_user_id: employees(admin_type).id
        end
      end
    end

    test 'should not get edit' do
      @invalid_admin_types.each do |admin_type|
        get :edit, { id: @title }, current_user_id: employees(admin_type).id
        assert_response :redirect
      end
    end

    test 'should not update title' do
      @invalid_admin_types.each do |admin_type|
        patch :update, { id: @title, title: { name: @title.name } }, current_user_id: employees(admin_type).id
        assert_not_nil flash[:error]
      end
    end

    test 'should not destroy title' do
      @invalid_admin_types.each do |admin_type|
        assert_no_difference('Title.count') do
          delete :destroy, { id: @title }, current_user_id: employees(admin_type).id
        end
      end
    end

    test 'user should not be able to see titles' do
      get :index, nil, current_user_id: employees(:consultant).id
      assert_redirected_to :root
      assert_not_nil flash[:error]
    end

    test 'inactive or contractor sys admin should not be able to see titles' do
      @invalid_admin_types.each do |admin_type|
        get :index, nil, current_user_id: employees(admin_type).id
        assert_redirected_to :root
        assert_not_nil flash[:error]
      end
    end

    test 'appropriate handling of unknown title' do
      request.env['HTTP_REFERER'] = root_url
      delete :destroy, { id: 121_323_132_142_414_214 }, current_user_id: employees(:sys_admin).id
      assert_not_nil flash[:error]
    end

    test 'should not be able to create a title with the same name' do
      post :create, { title: { name: @title.name } }, current_user_id: employees(:sys_admin).id
      assert_not_nil flash[:error]
    end

    test 'should not be able to update a title to a title with the same name' do
      put :update, { id: @title.id, title: { name: @manager_title.name } }, current_user_id: employees(:sys_admin).id
      assert_not_nil flash[:error]
    end
  end
end

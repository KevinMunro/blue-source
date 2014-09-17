module Admin
  class DepartmentsController < ApplicationController
    before_action :require_login
    before_action :must_be_system_admin, except: [:sub_departments, :employees]

    def index
      @margin = 20
    end
  end
end

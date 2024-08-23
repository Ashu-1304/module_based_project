require 'rails_helper'
include Warden::Test::Helpers

describe Admin::DepartmentsController, type: :controller do

  include Devise::Test::ControllerHelpers
  render_views
  before(:each) do
    @admin = AdminUser.create(email: "admin@example.com")
    @admin.password = "password"
    @admin.role = "admin"
    @admin.save
    sign_in @admin
    @course = BxBlockForm::Course.create(name: "Btech", duration: "four_years", fees: 480000)
    @department = BxBlockForm::Department.create(name: 'CSE', course_id: @course.id)
  end
  let(:department_params) do
    {
        name: @department.name,
        course_id: @department.course_id
    }
  end

  describe 'create department' do
    it 'successful creation' do
      post :new, params: department_params
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show department' do
    it 'successful show' do
      get :show, params: {id: @department.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show all department' do
    it 'shows the departments' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

end
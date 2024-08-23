require 'rails_helper'
include Warden::Test::Helpers

describe Admin::CollegesController, type: :controller do

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
    @college = BxBlockForm::College.create(name: "MITS", address: "Race course road, Gole ka mandir", city: "Gwalior", state: "Madhyapradesh", postal_code: '477112', phone: '7089287987', email: 'mits@yopmail.com', description: 'Best college but zero placement', course_name: @course.name, course_department: @department.name)
  end
  let(:college_params) do
    {
        name: @college.name,
        address: @college.address,
        city: @college.city,
        state: @college.state,
        postal_code: @college.postal_code,
        phone: @college.phone,
        email: @college.email,
        description: @college.description,
        course_name: @college.course_name,
        course_department: @college.course_department
    }
  end

  describe 'create college' do
    it 'successful creation' do
      post :new, params: college_params
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show college' do
    it 'successful show' do
      get :show, params: { course_id: @course.id, id: @college.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns error' do
      get :show, params: { course_id: 999, id: @college.id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'show all college' do
    it 'shows the colleges' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

end
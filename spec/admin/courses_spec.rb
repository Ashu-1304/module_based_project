require 'rails_helper'
include Warden::Test::Helpers

describe Admin::CoursesController, type: :controller do

  include Devise::Test::ControllerHelpers
  render_views
  before(:each) do
    @admin = AdminUser.create(email: "admin@example.com")
    @admin.password = "password"
    @admin.role = "admin"
    @admin.save
    sign_in @admin
    @course = BxBlockForm::Course.create(name: "Btech", duration: "four_years", fees: 480000)
  end
  let(:course_params) do
    {
        name: @course.name,
        duration: @course.duration,
        fees: @course.fees
    }
  end

  describe 'create course' do
    it 'successful creation' do
      post :new, params: course_params
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show course' do
    it 'successful show' do
      get :show, params: {id: @course.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show all course' do
    it 'shows the courses' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

end
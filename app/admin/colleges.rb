ActiveAdmin.register BxBlockForm::College, as: "Colleges" do
  permit_params :name, :address, :city, :state, :postal_code, :phone, :email, :description, :course_name, :course_department

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :state
    column :city
    column :postal_code
    column :address
    column :description
    column :course_name
    column :course_department
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :state
      f.input :city
      f.input :postal_code
      f.input :address
      f.input :description
      f.input :course_name, as: :select, collection: BxBlockForm::Course.all.pluck(:name, :id), input_html: { id: 'course_name_select' }
      f.input :course_department, as: :select, collection: [], input_html: { id: 'course_department_select' }
    end
    f.actions
  end

  controller do
    def show
      course = BxBlockForm::Course.find(params[:course_id])
      departments = course.departments.pluck(:name, :id)
      render json: departments
    rescue ActiveRecord::RecordNotFound
      render json: [], status: :not_found
    end
  end
 
end
  
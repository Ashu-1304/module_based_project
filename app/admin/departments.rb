ActiveAdmin.register BxBlockForm::Department, as: "Departments" do
    permit_params :name, :course_id
  
    index do
      selectable_column
      id_column
      column :name
      column :course do |department|
        department.course.name if department.course.present?
      end
      actions
    end
  
    show do
      attributes_table do
        row :name
        row :course do |department|
            department.course.name if department.course.present?
        end
      end
    end
  
    form do |f|
      f.inputs do
        f.input :course_id, as: :select, collection: BxBlockForm::Course.all.pluck(:name, :id)
        f.input :name
      end
      f.actions
    end
  
  end
    
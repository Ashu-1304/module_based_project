ActiveAdmin.register BxBlockForm::Course, as: "Courses" do
  permit_params :name, :duration, :fees

  index do
    selectable_column
    id_column
    column :name
    column :departments
    column :duration
    column :fees
    actions
  end

  show do
    attributes_table do
      row :name
      row :departments
      row :duration
      row :fees
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :duration, as: :select
      f.input :fees
    end
    f.actions
  end

end
  
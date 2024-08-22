ActiveAdmin.register BxBlockAccountBlock::Account, as: "Accounts" do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation

  index do
      selectable_column
      id_column
      column :first_name
      column :last_name
      column :email
      actions
  end

  show do
      attributes_table do
          row :first_name
          row :last_name
          row :email
      end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def scoped_collection
      policy_scope(BxBlockAccountBlock::Account)
    end

    def create
      authorize BxBlockAccountBlock::Account
      super
    end

    def update
      authorize resource
      super
    end

    def destroy
      authorize resource
      super
    end

    private

    def pundit_user
      current_admin_user
    end
  end

end
  
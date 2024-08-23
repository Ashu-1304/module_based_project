ActiveAdmin.register BxBlockAccountBlock::SmtpSetting , as: "Smtp Credentials" do
  permit_params :username, :smtp_password, :enable_starttls_auto 

  index do
    selectable_column
    id_column
    column :username
    column :smtp_password
    column :enable_starttls_auto
    actions
  end

  controller do 
    def create 
      super 
    end
  end
  
end

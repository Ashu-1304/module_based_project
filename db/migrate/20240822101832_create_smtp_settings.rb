class CreateSmtpSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :smtp_settings do |t|
      t.string :username
      t.string :smtp_password
      t.boolean :enable_starttls_auto

      t.timestamps
    end
  end
end

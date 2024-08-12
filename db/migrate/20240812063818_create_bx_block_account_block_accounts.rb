class CreateBxBlockAccountBlockAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bx_block_account_block_accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :email
      t.integer :full_phone_number 
      t.boolean :activated, default: false  
      t.timestamps
    end
  end
end

class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :country
      t.string :address
      t.string :postal_code
      t.integer :account_id
      t.integer :profile_role
      t.string :city
      t.timestamps
    end
  end
end
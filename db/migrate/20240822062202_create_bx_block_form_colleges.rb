class CreateBxBlockFormColleges < ActiveRecord::Migration[7.1]
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :state
      t.string :city
      t.string :postal_code
      t.text :address
      t.text :description
      t.string :course_name
      t.string :course_department

      t.timestamps
    end
  end
end

class CreateBxBlockFormCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :duration
      t.integer :fees

      t.timestamps
    end
  end
end

class CreateBxBlockFormDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.references :course, foreign_key: true
      t.timestamps
    end
  end
end

class CreateCollegesCoursesJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :colleges, :courses, table_name: :colleges_courses do |t|
      t.index :college_id
      t.index :course_id
    end
  end
end

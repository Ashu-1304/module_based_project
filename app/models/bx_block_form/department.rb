module BxBlockForm
  class Department < ApplicationRecord
    self.table_name = :departments
    belongs_to :course, class_name: "BxBlockForm::Course", dependent: :destroy

    validates :name, :course_id, presence: true
  end
end

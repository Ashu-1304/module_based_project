module BxBlockForm
  class Course < ApplicationRecord
    self.table_name = :courses
    has_and_belongs_to_many :colleges, join_table: :colleges_courses
    has_many :departments, class_name: "BxBlockForm::Department", dependent: :destroy

    enum duration: { two_years: 0, three_years: 1, four_years: 2 }
    validates :name, presence: true, uniqueness: true
    validates :duration, :fees, presence: true
  end
end

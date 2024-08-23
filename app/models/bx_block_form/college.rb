module BxBlockForm
  class College < ApplicationRecord
    self.table_name = :colleges
    has_and_belongs_to_many :courses, join_table: :colleges_courses

    validates :name, :address, :city, :state, :postal_code, :phone, :email, :description, presence: true
  end
end

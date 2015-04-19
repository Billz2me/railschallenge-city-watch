class Responder < ActiveRecord::Base
  # Disable Single table inheritance
  self.inheritance_column = :_type_disabled

  has_one :emergency

  validates :type, presence: true

  validates :name,
            presence: true,
            uniqueness: true

  validates :capacity,
            presence: true,
            inclusion: 1..5
end

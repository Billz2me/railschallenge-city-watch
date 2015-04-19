class Responder < ActiveRecord::Base
  # Disable STI
  self.inheritance_column = :_type_disabled
  self.primary_key = :name

  has_one :emergency

  validates :type, presence: true

  validates :name,
            presence: true,
            uniqueness: true

  validates :capacity,
            presence: true,
            inclusion: 1..5

  # Scope for Responders that are on duty.
  # Example: Responder.on_duty.where(...)
  scope :on_duty, -> { where(on_duty: true) }

  # Scope for Responders that have capacity greater than the provided capacity
  # Example: Responder.on_duty.with_capacity.where(...)
  scope :with_capacity, ->(capacity = 0) { where('capacity > ?', capacity) }
end

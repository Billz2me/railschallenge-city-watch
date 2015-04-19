class Responder < ActiveRecord::Base
  include ResponderCapacityReport

  # Disable STI
  self.inheritance_column = :_type_disabled
  self.primary_key = :name

  # Public: Constant - a list of possible Responder types.
  TYPES = %w( Fire Police Medical )

  has_one :emergency

  validates :type, presence: true

  validates :name,
            presence: true,
            uniqueness: true

  validates :capacity,
            presence: true,
            inclusion: 1..5

  # Public: Scope for Responders that are on duty.
  scope :on_duty, -> { where(on_duty: true) }

  # Public: Scope for Responders that have capacity greater than the provided capacity.
  scope :with_capacity, ->(capacity = 0) { where('capacity > ?', capacity) }

  # Public: Scope for Responders who are not currently assigned to an emergency.
  scope :available, -> { where(emergency_code: nil) }
end

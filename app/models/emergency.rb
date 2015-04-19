class Emergency < ActiveRecord::Base
  include EmergencyDispatcher

  after_update :release_responders, if: :resolved?

  self.primary_key = :code

  has_many :responders, foreign_key: :emergency_code

  validates :code,
            presence: true,
            uniqueness: true

  validates :fire_severity, :police_severity, :medical_severity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scope for Emergency that had a full_response.
  # Example: Emergency.full_response.count
  scope :full_response, -> { where(full_response: true) }

  # Public: Get all severities in a Hash.
  #
  # Returns a Hash of { severity_type => severity }
  def severities
    { fire: fire_severity,
      police: police_severity,
      medical: medical_severity }
  end

  # Public: Return a boolean indicating whether or not this emergency has been resolved.
  def resolved?
    resolved_at.present?
  end

  private

  # Internal: Release all the responders for this emergency.
  def release_responders
    responders.update_all(emergency_code: nil)
  end
end

class Emergency < ActiveRecord::Base
  self.primary_key = :code

  has_many :responders, foreign_key: :emergency_code

  validates :code,
            presence: true,
            uniqueness: true

  validates :fire_severity, :police_severity, :medical_severity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Public: Get all severities in a Hash.
  #
  # Returns a Hash of { severity_type => severity }
  def severities
    { fire: fire_severity,
      police: police_severity,
      medical: medical_severity }
  end
end

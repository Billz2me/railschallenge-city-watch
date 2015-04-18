class Emergency < ActiveRecord::Base

  validates_uniqueness_of :code
  validates_presence_of :code, :fire_severity, :police_severity, :medical_severity 
  validates_numericality_of [:fire_severity, :police_severity, :medical_severity], greater_than_or_equal_to: 0

end

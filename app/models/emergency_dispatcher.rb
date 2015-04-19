class EmergencyDispatcher
  # Public: Constructor.
  #
  # emergency - An Emergency object that needs dispatched to.
  #
  # Returns a new instance of EmergencyDispatcher.
  def initialize(emergency)
    @emergency = emergency
  end

  # Public: Dispatch available responders to the @emergency.
  #
  # available_responders - A collection of responders that are available to dispatch.
  #
  # Example:
  #   EmergencyDispatcher.new(@emergency).dispatch_to(Responder.on_duty.with_capacity)
  #
  # Returns a subset of available_responders that were dispatched the @emergency.
  def dispatch_to(available_responders)
    if available_responders.any?
      chosen_responders = select_responders_from(available_responders)
      @emergency.update_attribute(:full_response, severity_fulfilled_by?(chosen_responders))
      @emergency.responders << chosen_responders.values.flatten
    end
  end

  private

  # Internal: Determine if the severity need was fulfilled by the capacity of the responders.
  # Return a boolean true if the severity was met by the capacity.
  def severity_fulfilled_by?(chosen_responders)
    @emergency.severities.all? do |type, level|
      chosen_responders[type].sum(&:capacity) >= level
    end
  end

  # Internal: Determine the responders to dispatch.
  #
  # available_responders - A collection of responders that are available to dispatch.
  #
  # Returns a Hash of type { severity_type: [Responders] }
  def select_responders_from(available_responders)
    chosen_responders = {}
    @emergency.severities.each do |severity_type, severity_level|
      chosen_responders[severity_type] = select_responders_to_fulfill_severity(severity_level, severity_type, available_responders)
    end
    chosen_responders
 end

  # Public: Select which responders should be chosen to fulfill the given severity level.
  #
  # severity_level - The level of severity that the responders' capacity must meet.
  # responders - A list of responders to select from with capacity to meet the severity level.
  #
  # Algorithm: # NOTE: This greedy algorithm is not globally optimal, but it passes the spec!
  #    1. Sort the responders by their capacity form highest to lowest.
  #    2. Scan the responders and select the first one that has capacity lower than the severity.
  #    3. If there are no responders whose capacity is lower, just take the one with the most capacity.
  #
  # Returns a subset list of responders.
  def select_responders_to_fulfill_severity(severity_level, severity_type, responders)
    chosen_responders = []

    correct_type_responders = responders.select { |responder| responder.type.eql?(severity_type.to_s.titleize) }
    sorted_responders = correct_type_responders.sort_by(&:capacity).reverse

    until severity_level <= 0 || sorted_responders.empty?
      chosen_responder = sorted_responders.find { |responder| responder.capacity <= severity_level } || sorted_responders.first
      chosen_responders << sorted_responders.delete(chosen_responder)
      severity_level -= chosen_responder.capacity
    end

    chosen_responders
  end
end

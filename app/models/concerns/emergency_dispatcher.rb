module EmergencyDispatcher
  extend ActiveSupport::Concern

  # Public: Dispatch available responders to the @emergency.
  #
  # available_responders - A collection of responders that are available to dispatch.
  #
  # Returns a subset of available_responders that were dispatched the @emergency.
  def dispatch_to(available_responders)
    return if available_responders.none?
    chosen_responders = select_responders_from(available_responders)
    transaction do
      update_attribute(:full_response, severity_fulfilled_by?(chosen_responders))
      responders << chosen_responders.values.flatten
    end
  end

  private

  # Internal: Determine if the severity for the @emergency was fulfilled by the capacity of the responders.
  # Return a boolean true if the severity was met by the capacity.
  def severity_fulfilled_by?(chosen_responders)
    severities.all? { |type, level| chosen_responders[type].sum(&:capacity) >= level }
  end

  # Internal: Determine the responders to dispatch.
  #
  # available_responders - A collection of responders that are available to dispatch.
  #
  # Returns a Hash of type { severity_type: [Responders] }
  def select_responders_from(available_responders)
    chosen_responders = {}
    severities.each do |severity_type, severity_level|
      chosen_responders[severity_type] = responders_for(severity_level, severity_type, available_responders)
    end
    chosen_responders
  end

  # Public: Select which responders should be chosen to fulfill the given severity level.
  #
  # severity_level - The level of severity that the responders' capacity must meet.
  # severity_type - The type of severity to select responders for (e.g. :fire, 'Fire')
  # responders - A list of responders to select from with capacity to meet the severity level.
  #
  # Algorithm: # NOTE: This greedy algorithm is not globally optimal, but it passes the spec!
  #    1. Sort the responders by their capacity form highest to lowest.
  #    2. Scan the responders and select the first one that has capacity lower than the severity.
  #    3. If there are no responders whose capacity is lower, just take the one with the most capacity.
  #
  # Returns a subset list of responders.
  def responders_for(severity_level, severity_type, responders)
    chosen_responders = []

    correct_type_responders = responders.select { |responder| responder.type.eql?(severity_type.to_s.titleize) }
    sorted_responders = correct_type_responders.sort_by(&:capacity).reverse

    until severity_level <= 0 || sorted_responders.empty?
      responder = choose_responder(severity_level, sorted_responders)
      chosen_responders << sorted_responders.delete(responder)
      severity_level -= responder.capacity
    end

    chosen_responders
  end

  # Internal: Choose a responder from a list of sorted responders.
  #
  # severity_level - The severity level that the chosen responder should try to satisfy.
  # sorted_responders - A list of Responder, sorted by capacity from highest to lowest.
  #
  # Returns a Responder from the list.
  def choose_responder(severity_level, sorted_responders)
    chosen_responder = sorted_responders.find { |responder| responder.capacity <= severity_level }
    chosen_responder || sorted_responders.first
  end
end

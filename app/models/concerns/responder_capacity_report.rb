module ResponderCapacityReport
  extend ActiveSupport::Concern

  module ClassMethods
    # Public: Generate the capacity report for Responders of all types.
    def capacity_report
      Responder::TYPES.each_with_object({}) do |responder_type, report_hash|
        report_hash[responder_type] = capacity_report_for(responder_type)
        report_hash
      end
    end

    private

    # Internal: Generate the capacity report for a given type of Responder.
    #
    # responder_type - Expects a value from Responder::TYPES.
    #
    # Returns an Array of capacity sums.
    def capacity_report_for(responder_type)
      base_query = Responder.where(type: responder_type)
      [base_query.sum(:capacity),
       base_query.available.sum(:capacity),
       base_query.on_duty.sum(:capacity),
       base_query.available.on_duty.sum(:capacity)]
    end
  end
end

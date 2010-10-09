module Komando
  module Command

    def self.run!(instance_variable_declarations)
      new.run!(instance_variable_declarations)
    end

    def initialize(instance_variable_declarations={})
      instance_variable_declarations.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    def run!
      run_mandatory!

      steps = self.class.instance_variable_get("@best_effort_steps")
      return true unless steps.kind_of?(Enumerable)

      steps.each do |name, block|
        begin
          instance_exec &block
        rescue RuntimeError => e
          Rails.logger.warn "Ignoring failed #{name} step in #{self.class}: #{e.class.name} - #{e.message}"
        end
      end
    end

    private

    def run_mandatory!
      mandatory = self.class.mandatory_steps
      raise Komando::MissingMandatoryStepsError unless mandatory
      instance_exec(&mandatory)
    end

  end
end

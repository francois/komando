module Komando
  module Command

    # Instantiates and runs this command.
    #
    # @param (see #initialize)
    # @return [true] When the mandatory parts of the command are run to completion.
    def self.run!(instance_variable_declarations)
      new.run!(instance_variable_declarations)
    end

    # @param [Hash] instance_variable_declarations The list of instance variables to declare on this instance.
    # The instance variables will be available in the blocks, courtesy of Ruby
    # and it's dynamic nature.
    def initialize(instance_variable_declarations={})
      instance_variable_declarations.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    # Executes the mandatory and best effort steps, in order of definition, raising or
    # logging and swallowing exceptions as appropriate.
    #
    # @return [true] Always returns +true+, since exceptions indicate failure.
    # @raise [Exception] In case of a failure in the mandatory part of the command.
    def run!
      run_mandatory!

      steps = self.class.instance_variable_get("@best_effort_steps")
      steps.each do |name, block|
        begin
          instance_exec &block
        rescue RuntimeError => e
          Rails.logger.warn "Ignoring failed #{name} step in #{self.class}: #{e.class.name} - #{e.message}"
        end
      end

      true
    end

    private

    # Runs and raises
    def run_mandatory!
      mandatory = self.class.mandatory_steps
      raise Komando::MissingMandatoryStepsError unless mandatory
      instance_exec(&mandatory)
    end

  end
end

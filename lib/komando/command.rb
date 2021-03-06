module Komando
  module Command

    autoload :Dsl, "komando/command/dsl"

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
      run_best_effort
      true
    end

    # Returns a Logger-like object that will log receive #warn, #info and #debug calls.
    # The logger can do whatever it wants with those calls.
    #
    # @return [#warn, #info, #debug] A Logger-like object that responds to logging commands.
    #
    # @example
    #
    #   # config/initializers/komando.rb
    #   require "komando/command"
    #
    #   module Komando::Command
    #     def logger
    #       Rails.logger
    #     end
    #   end
    def logger
      @logger ||= Logger.new(STDERR)
    end

    private

    # Runs and raises
    def run_mandatory!
      steps = self.class.mandatory_steps
      raise Komando::MissingMandatoryStepsError if steps.empty?
      steps.each do |step|
        instance_exec(&step)
      end
    end

    # Runs and logs
    def run_best_effort
      self.class.best_effort_steps.each do |name, block|
        begin
          instance_exec &block
        rescue StandardError => e
          logger.warn "[Komando] Ignoring failed #{name.inspect} step in #{self.class}: #{e.class.name} - #{e.message}"
        end
      end
    end

  end
end

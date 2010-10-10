# The main Komando module. Holder for declarations.
module Komando

  # Indicates the mandatory steps have not been declared on instances of this class.
  class MissingMandatoryStepsError < StandardError; end

  # Indicates you tried to declare multiple mandatory steps. Instead of doing that, declare methods and call them.
  #
  # @see Komando::Command::Dsl
  class MultipleMandatoryStepDeclarationsError < StandardError
    def initialize(*args)
      super("Mandatory step blocks can only be declared once per command - declare methods and call the methods from your block")
    end
  end

  autoload :Command, "komando/command"

  def self.make_command(base)
    base.send :include, Komando::Command
    base.send :extend, Komando::Command::Dsl
    if defined?(ActiveRecord) then
      require "komando/persistence/active_record"
      base.send :include, Komando::Persistence::ActiveRecord
    end
  end

end

# The main Komando module. Holder for declarations.
module Komando

  # Indicates the mandatory steps have not been declared on instances of this class.
  class MissingMandatoryStepsError < StandardError; end

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

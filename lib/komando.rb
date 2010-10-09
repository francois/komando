module Komando

  class MissingMandatoryStepsError < RuntimeError; end
  class MultipleMandatoryStepDeclarationsError < RuntimeError
    def initialize(*args)
      super("Mandatory step blocks can only be declared once per command - declare methods and call the methods from your block")
    end
  end

end

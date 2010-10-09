require "spec_helper"

describe "A command with no step declarations" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command
    end
  end

  should "have no mandatory step block" do
    @command.mandatory_steps.should.be.nil?
  end

  should "have no best effort blocks" do
    @command.best_effort_steps.should == []
  end

  should "raise an exception when running" do
    lambda { @command.new.run! }.should.raise(Komando::MissingMandatoryStepsError)
  end
end

describe "A command with one mandatory step block and no best effort blocks" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command

      mandatory_steps do
      end
    end
  end

  should "have a mandatory step block" do
    @command.mandatory_steps.should.not.be.nil?
  end

  should "NOT allow declaring a second one" do
    lambda do
      @command.class_exec do
        mandatory_steps do
        end
      end
    end.should.raise(Komando::MultipleMandatoryStepDeclarationsError)
  end

end

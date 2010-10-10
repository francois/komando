require "spec_helper"

describe "A command with no step declarations" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
    end
  end

  should "have no mandatory step blocks" do
    @command.mandatory_steps.should == []
  end

  should "have no best effort blocks" do
    @command.best_effort_steps.should == []
  end
end

describe "A command with one mandatory step block and no best effort blocks" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl

      mandatory_step do
      end
    end
  end

  should "have a mandatory step block" do
    @command.mandatory_steps.should.not.be.nil?
  end

  should "allow declaring a second mandatory step" do
    lambda do
      @command.class_eval do
        mandatory_step do
        end
      end
    end.should.not.raise
  end

end

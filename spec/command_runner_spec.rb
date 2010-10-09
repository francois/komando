require "spec_helper"

describe "A command with a mandatory step" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command

      attr_reader :ran

      mandatory_steps do
        @ran = true
      end
    end
  end

  should "run the mandatory steps" do
    command = @command.new
    command.run!

    command.ran.should == true
  end

end

describe "A command with a failing mandatory step" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command

      attr_reader :ran, :log

      mandatory_steps do
        raise "failure to run"
      end

      best_effort_step do
        @log ||= []
        @log << 1
      end
    end
  end

  should "let the exception bubble through" do
    lambda do
      @command.new.run!
    end.should.raise(RuntimeError)
  end

  should "NOT run best effort blocks" do
    command = @command.new
    begin
      command.run!
    rescue StandardError => ignored
      # NOP
    end

    command.log.should.be.nil?
  end

end

describe "A command with no step declarations" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command
    end
  end

  should "raise an exception when running" do
    lambda { @command.new.run! }.should.raise(Komando::MissingMandatoryStepsError)
  end

end

describe "A command with a best effort step" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command

      attr_reader :ran

      mandatory_steps do
        # NOP
      end

      best_effort_step(:always_succeeds) do
        @ran = true
      end
    end
  end

  should "run the best effort step" do
    command = @command.new
    command.run!
    command.ran.should == true
  end

end

describe "A command with two best effort steps" do

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command

      attr_reader :log

      mandatory_steps do
        # NOP
      end

      best_effort_step(:first) do
        @log ||= []
        @log << 1
      end

      best_effort_step(:second) do
        @log ||= []
        @log << 2
      end
    end
  end

  should "run both blocks, in order" do
    command = @command.new
    command.run!
    command.log.should == [1, 2]
  end

end

describe "A command with two best effort steps, where the 1st will fail" do

  after do
    $OK = false
  end

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command

      attr_reader :log

      mandatory_steps do
        # NOP
      end

      best_effort_step(:first) do
        raise "failure to run"
      end

      best_effort_step(:second) do
        @log ||= []
        @log << 2
      end

      def logger
        @logger ||= Class.new do
          attr_reader :messages

          def warn(message)
            @messages ||= []
            @messages << message
          end
        end.new
      end
    end
  end

  should "run both blocks, in order, and not return errors" do
    command = @command.new
    command.run!
    command.log.should == [2]
  end

  should "log errors using #logger" do
    command = @command.new
    command.run!
    messages = command.logger.messages

    messages.length.should == 1
    messages.first.should.match /^ignoring failed.*first.*RuntimeError.*failure to run/im
  end

end

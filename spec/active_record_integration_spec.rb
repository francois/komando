require "spec_helper"
require "komando/persistence/active_record"

describe "An active-record enabled command" do

  before do
    ActiveRecord::Base.establish_connection :adapter => adapter_name, :database => ":memory:"
  end

  def adapter_name
    return "jdbcsqlite3" if defined?(JRUBY_VERSION)
    return "sqlite3"
  end

  before do
    @command = Class.new do
      extend Komando::Command::Dsl
      include Komando::Command
      include Komando::Persistence::ActiveRecord

      attr_reader :open_transactions

      mandatory_steps do
        @open_transactions = ActiveRecord::Base.connection.open_transactions
      end
    end
  end

  should "wrap the mandatory_steps within an ActiveRecord transaction" do
    command = @command.new
    command.run!
    command.open_transactions.should == 1
  end

end

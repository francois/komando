require 'test_helper'

class CreateUserCommandTest < ActiveSupport::TestCase

  def setup
    ActionMailer::Base.deliveries = []
    @redis = LoggingRedis.new
  end

  def teardown
    ActionMailer::Base.deliveries = []
  end

  test "Creating with known good email address creates record, adds member to 'signup:TODAY' in Redis and sends invitation email" do
    command = CreateUserCommand.new(:attributes => {:email => "jill@teksol.info"},
                                    :redis      => @redis)
    command.run!

    user = command.user
    assert_not_nil user
    assert !user.new_record?

    assert_nil user.username
    assert_nil user.password

    assert_equal 1, ActionMailer::Base.deliveries.length, "Invitation/Welcome email not sent"

    assert_equal [[:sadd, "signup:#{Date.today.to_s(:db)}", user.id]], @redis.log
  end

  test "Creating with missing email address should raise a record invalid exception" do
    assert_raise ActiveRecord::RecordInvalid do
      command = CreateUserCommand.new(:attributes => {:email => ""},
                                      :redis      => @redis)
      command.run!
    end
  end

end

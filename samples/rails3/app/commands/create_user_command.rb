# A simple user creation command.
#
# When creating users, we're in fact inviting them in. They should be sent an email
# that confirms their email address is valid, and from which they will have a
# URL to confirm their intent on signing up.
class CreateUserCommand

  Komando.make_command self

  attr_reader :user

  # Exceptions raised from here will bubble up to the caller.
  mandatory_steps do
    @user = User.invite!(@attributes)
  end

  # Exceptions raised from here will be logged and swallowed.
  # Many of these blocks can be specified, and they will be run once
  # each. Failure to run one block won't stop the others from running.
  best_effort_step(:invitation_email) do
    UserMailer.invitation_email(@user).deliver
  end

  best_effort_step(:signup_stats) do
    @redis.sadd("signup:#{Date.today.to_s(:db)}", @user.id)
  end

end

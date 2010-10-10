class ConfirmUserInvitationCommand

  Komando.make_command self

  def user
    @user ||= User.find_invited_by_token(@token)
  end

  mandatory_steps do
    user.activate!(@attributes)
  end

  best_effort_step(:welcome_email) do
    UserMailer.welcome_email(user).deliver
  end

  best_effort_step(:signup_stats) do
    @redis.sadd("confirm:#{Date.today.to_s(:db)}", user.id)
  end

end

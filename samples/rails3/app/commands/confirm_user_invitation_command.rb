class ConfirmUserInvitationCommand

  Komando.make_command self

  mandatory_steps do
    @user = User.invited.with_token(@token).find(@id)
    @user.activate!
  end

  best_effort_step(:welcome_email) do
    UserMailer.welcome_email(@user).deliver
  end

  best_effort_step(:signup_stats) do
    @redis.sadd("confirm:#{Date.today.to_s(:db)}", @user.id)
  end

end

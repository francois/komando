class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def invitation_email(user)
    @user = user
    mail :to => user.email, :subject => "Signup to app to continue"
  end

  def welcome_email(user)
    @user = user
    mail :to => user.email, :subject => "Welcome to our app"
  end

end

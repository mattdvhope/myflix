class AppMailer < ActionMailer::Base
  default from: "info@myflix.com"

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyFlix!"
  end
end

class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@muvi.com", subject: "Welcome to Muvi!"
  end

  def send_forgot_password(user)
    mail to: user.email, from: "info@muvi.com", subject: "Please reset your password"
  end
end
class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@muvi.com", subject: "Welcome to Muvi!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@muvi.com", subject: "Please reset your password"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, from: "info@muvi", subject: "Join Muvi invite"
  end
end
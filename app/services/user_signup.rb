class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => stripe_token,
        :description => "cause you're a sucker #{@user.email}"
      )
      if charge.successful?
        @user.save
        invitation_handler(invitation_token)
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information"
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def invitation_handler(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end
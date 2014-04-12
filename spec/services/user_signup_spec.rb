require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true )}

      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "create a user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_tripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        daddy = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: daddy, recipient_email: 'daddy_o@daddy.com')
        UserSignup.new(Fabricate.build(:user, email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O')).sign_up("some_tripe_token", invitation.token)
        daddy_o = User.where(email: 'daddy_o@daddy.com').first
        expect(daddy_o.follows?(daddy)).to be_true
      end

      it "makes the inviter follow the user" do
        daddy = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: daddy, recipient_email: 'daddy_o@daddy.com')
        UserSignup.new(Fabricate.build(:user, email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O')).sign_up("some_tripe_token", invitation.token)
        daddy_o = User.where(email: 'daddy_o@daddy.com').first
        expect(daddy.follows?(daddy_o)).to be_true
      end


      it "expires the invitation upon acceptance" do
        daddy = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: daddy, recipient_email: 'daddy_o@daddy.com')
        UserSignup.new(Fabricate.build(:user, email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O')).sign_up("some_tripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'daddy_o@daddy.com')).sign_up("some_tripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['daddy_o@daddy.com'])
      end

      it "sends out email the user's name eith valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O')).sign_up("some_tripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Daddy O")
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message:"Your card was declined" )
        StripeWrapper::Charge.stub(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up('1231241', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do

      it "does not create the user" do
        UserSignup.new(User.new(email: "daddy@daddy.com")).sign_up('1231241', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(email: "daddy@daddy.com")).sign_up('1231241', nil)
      end

      it "does not sign up email with invalid inputs" do
        UserSignup.new(User.new(email: "daddy@daddy.com")).sign_up('1231241', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end


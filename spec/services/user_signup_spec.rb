require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true )}

      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "create a user" do
        posty :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        daddy = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: daddy, recipient_email: 'daddy_o@daddy.com')
        post :create, user: {email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O'}, invitation_token: invitation.token
        daddy_o = User.where(email: 'daddy_o@daddy.com').first
        expect(daddy_o.follows?(daddy)).to be_true
      end

      it "makes the inviter follow the user" do
        daddy = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: daddy, recipient_email: 'daddy_o@daddy.com')
        post :create, user: {email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O'}, invitation_token: invitation.token
        daddy_o = User.where(email: 'daddy_o@daddy.com').first
        expect(daddy.follows?(daddy_o)).to be_true
      end


      it "expires the invitation upon acceptance" do
        daddy = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: daddy, recipient_email: 'daddy_o@daddy.com')
        post :create, user: {email: 'daddy_o@daddy.com', password: "password", full_name: 'Daddy O'}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end
  end
end


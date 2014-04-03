require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new}
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "Daddy O", recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Daddy O", recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Daddy O", recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['daddy_o@daddy.com'])
      end

      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Daddy O", recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "renders the :new template" do
        set_current_user
        post :create, invitation: { recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(response).to render_template :new
      end

      it "does not create invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out email" do
        set_current_user
        post :create, invitation: { recipient_email: "daddy_o@daddy.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(flash[:error]).to be_present
      end

      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "daddy_o@daddy.com", message: "Hey join Muvi!" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
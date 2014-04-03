require "spec_helper"

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      daddy = Fabricate(:user, token: '12345')
      daddy.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      daddy = Fabricate(:user, token: '12345')
      daddy.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
  end
end
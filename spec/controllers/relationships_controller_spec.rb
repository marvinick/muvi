require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to current user's following relationships" do
      daddy = Fabricate(:user)
      set_current_user(daddy)
      daddy2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: daddy, leader: daddy2)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end

    it "redirects to the people page" do
      daddy = Fabricate(:user)
      set_current_user(daddy)
      marvee = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: daddy, leader: marvee)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is the follower" do
      daddy = Fabricate(:user)
      set_current_user(daddy)
      marvee = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: daddy, leader: marvee)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      daddy = Fabricate(:user)
      set_current_user(daddy)
      marvee = Fabricate(:user)
      ace = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: ace, leader: marvee)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 3 }
    end

    it "redirects to the people page" do
      daddy = Fabricate(:user)
      marvee = Fabricate(:user)
      set_current_user(daddy)
      post :create, leader_id: marvee.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do
      daddy = Fabricate(:user)
      marvee = Fabricate(:user)
      set_current_user(daddy)
      post :create, leader_id: marvee.id
      expect(daddy.following_relationships.first.leader).to eq(marvee)
    end

    it "does not create a relationship if the current user already follows the leader" do
      daddy = Fabricate(:user)
      marvee = Fabricate(:user)
      set_current_user(daddy)
      Fabricate(:relationship, leader: marvee, follower: daddy)
      post :create, leader_id: marvee.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow one to follow himself" do
      daddy = Fabricate(:user)
      set_current_user(daddy)
      post :create, leader_id: daddy.id
      expect(Relationship.count).to eq(0)
    end
  end
end
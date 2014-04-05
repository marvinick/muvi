require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC")}

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video). should be_true
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_false
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      daddy = Fabricate(:user)
      marvee = Fabricate(:user)
      Fabricate(:relationship, leader: daddy, follower: marvee)
      expect(marvee.follows?(daddy)).to be_true
    end

    it "returns false if the user does not have a following relationship with another user" do
      daddy = Fabricate(:user)
      marvee = Fabricate(:user)
      Fabricate(:relationship, leader: daddy, follower: marvee)
      expect(daddy.follows?(marvee)).to be_false
    end
  end

  describe "#follow" do
    it "follows another user" do
      daddy = Fabricate(:user)
      daddy_o = Fabricate(:user)
      daddy.follow(daddy_o)
      expect(daddy.follows?(daddy_o)).to be_true
    end

    it "does not follow one self" do
      daddy = Fabricate(:user)
      daddy.follow(daddy)
      expect(daddy.follows?(daddy)).to be_false
    end
  end
end
require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns the videos in the reverse chronical order by created at" do
      comedies = Category.create(name: "comedies")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: comedies, created_at: 1.day.ago)
      south_park = Video.create(title: "Back To Future", description: "Time Travel", category: comedies)
      expect(comedies.recent_videos).to eq([south_park, futurama])
    end

    it "returns all the videos if there are less than 6 videos" do
      comedies = Category.create(name: "comedies")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: comedies, created_at: 1.day.ago)
      south_park = Video.create(title: "Back To Future", description: "Time Travel", category: comedies)
      expect(comedies.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      comedies = Category.create(name: "comedies")
      7.times {Video.create(title: "foo", description: "what??", category: comedies)}
      expect(comedies.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      comedies = Category.create(name: "comedies")
      6.times {Video.create(title: "foo", description: "what??", category: comedies)}
      tonights_show = Video.create(title: "Tonight SHow", description: "talk show", category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(tonights_show)
    end

    it "returns an empty array if the category does not have any videos" do
      comedies = Category.create(name: "comedies")
      expect(comedies.recent_videos).to eq([])
    end
  end
end
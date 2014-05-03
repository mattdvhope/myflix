require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of (:name) }

  describe "#recent_videos" do # 6 most recent videos; most recent video should be first
    it "returns empty array if no videos are in Category" do
      chase = Category.create(name: "Chase Movies")
      expect(chase.recent_videos).to eq([])
    end
    it "returns array of the videos in a category" do
      chase = Category.create(name: "Chase Movies")
      road_runner = Video.create(title: "Road Runner", description: "Chased constantly!", created_at: 2.days.ago)
      chase.videos << road_runner
      tom_jerry = Video.create(title: "Tom & Jerry", description: "Quite a cat & mouse scene!", created_at: 2.minutes.ago)
      chase.videos << tom_jerry
      expect(chase.recent_videos).to eq(chase.videos)
    end
    it "returns array of matched videos ordered by created_at" do
      chase = Category.create(name: "Chase Movies")
      road_runner = Video.create(title: "Road Runner", description: "Chased constantly!", created_at: 2.days.ago)
      chase.videos << road_runner
      tom_jerry = Video.create(title: "Tom & Jerry", description: "Quite a cat & mouse scene!", created_at: 2.minutes.ago)
      chase.videos << tom_jerry
      expect(chase.recent_videos).to eq([tom_jerry, road_runner])
    end
    it "returns 6 videos if there are more than 6 videos" do
      chase = Category.create(name: "Chase Movies")
      7.times { Video.create(title: "foo", description: "bar", category: chase) }
      expect(chase.recent_videos.count).to eq(6)
    end
  end
end

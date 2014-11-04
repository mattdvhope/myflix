require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe "#search_by_title" do
    it "returns empty array if zero videos are found / no match" do
      bugs_bunny = Video.create(title: "Bugs Bunny", description: "Chasing rabbits")
      ben_hur = Video.create(title: "Ben Hur", description: "Roman circus maximus")
      expect(Video.search_by_title("hello")).to eq([])
    end
    it "returns array of one video if title matches exactly" do
      bugs_bunny = Video.create(title: "Bugs Bunny", description: "Chasing rabbits")
      ben_hur = Video.create(title: "Ben Hur", description: "Roman circus maximus")
      expect(Video.search_by_title("Bugs Bunny")).to eq([bugs_bunny])
    end
    it "returns array of one video  if partially matched" do
      bugs_bunny = Video.create(title: "Bugs Bunny", description: "Chasing rabbits")
      ben_hur = Video.create(title: "Ben Hur", description: "Roman circus maximus")
      expect(Video.search_by_title("s Bunn")).to eq([bugs_bunny])
    end
    it "returns array of matched videos ordered by created_at" do
      bugs_bunny = Video.create(title: "Bugs Bunny", description: "Chasing rabbits", created_at: 1.day.ago)
      bugs_hur = Video.create(title: "Bugs Hur", description: "Rabbit circus maximus")
      expect(Video.search_by_title("Bugs")).to eq([bugs_hur, bugs_bunny])
    end
    it "returns empty array for search with empty string" do
      bugs_bunny = Video.create(title: "Bugs Bunny", description: "Chasing rabbits", created_at: 1.day.ago)
      bugs_hur = Video.create(title: "Bugs Hur", description: "Rabbit circus maximus")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#rating_average" do
    it "returns average rating (whole number) if any rating exists" do
      bugs_hur = Video.create(title: "Bugs Hur", description: "Rabbit circus maximus")
      bad_rev = Review.create(video: bugs_hur, content: "Bad", rating: 1)
      mid_rev = Review.create(video: bugs_hur, content: "Mid", rating: 4)
      expect(bugs_hur.rating_average).to eq(2)
    end
    it "returns no rating if no ratings exist" do
      bugs_hur = Video.create(title: "Bugs Hur", description: "Rabbit circus maximus")
      expect(bugs_hur.rating_average).to eq(0)
    end
  end
end

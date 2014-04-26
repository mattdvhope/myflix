require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

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
end

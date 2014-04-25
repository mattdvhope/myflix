require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do

    # 1. Where you cannot find a single video
    it "returns empty array if zero videos are found" do
      videos_found = Video.find(title: "Fancy title")
      expect(videos_found.title_only?).to eq(true)
    end

    # 2. Where you can find one
    it "returns an array with one video title if one video is found" do
      videos_found = Video.new(title: "Fancy title", description: "")
      expect(videos_found.title_only?).to eq(true)
    end

    # 3. Where you can find multiple videos.
    it "returns an array with multiple video titles if more than one video is found" do
      videos_found = Video.new(title: "Fancy title", description: "Description")
      expect(videos_found.title_only?).to eq(false)
    end

  end
end

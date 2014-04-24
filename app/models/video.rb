class Video < ActiveRecord::Base

  belongs_to :category
  validates_presence_of :title, :description

  # Write tests BEFORE you write this method w/ several test cases: 1. Where you cannot find a single video; 2. Where you can find one; 3. Where you can find multiple videos.
  # def self.search_by_title(search_term) # Video.search_by_title("family") <--If "Family Guy" is one of the videos, it should find that video. If not videos are found return an empty array.  If finds more than one video, then it should return an array of the video titles.
  end

end

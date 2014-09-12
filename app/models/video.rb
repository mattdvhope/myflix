class Video < ActiveRecord::Base

  belongs_to :category
  has_many :reviews, ->{ order("created_at DESC") }

  mount_uploader :large_cover, LargeCoverUpLoader
  mount_uploader :small_cover, SmallCoverUpLoader

  validates_presence_of :title, :description

  # Write tests BEFORE you write this method w/ several test cases: 1. Where you cannot find a single video; 2. Where you can find one; 3. Where you can find multiple videos.
  def self.search_by_title(search_term) # Video.search_by_title("family") <--If "Family Guy" is one of the videos, it should find that video. If not videos are found return an empty array.  If finds more than one video, then it should return an array of the video titles.
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

end

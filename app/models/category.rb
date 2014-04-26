class Category < ActiveRecord::Base

  has_many :videos, ->{ order("created_at DESC") }

  def recent_videos # 6 most recent videos; most recent video should be first
    self.videos.first(6)
  end

end

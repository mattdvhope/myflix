class Category < ActiveRecord::Base

  has_many :videos, ->{ order("created_at DESC") }
  validates_presence_of :name

  def recent_videos # 6 most recent videos; most recent video should be first
    self.videos.first(6) # don't necessarily need 'self.'
  end

end

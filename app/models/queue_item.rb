class QueueItem < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  # This 'delegate' is the same as the code below.... The #category method (category of video) is now available to the QueueItem object.
  # def category
  #   video.category
  # end

  delegate :title, to: :video, prefix: :video
  # This 'delegate' is the same as the code below.... We add the prefix b/c we want the title method to be called on 'video' rather than 'queue_item'.
  # def video_title
  #   video.title
  # end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def category_name
    category.name # It's this rather than 'video.category.name' b/c of the 'delegate' above.
  end

end

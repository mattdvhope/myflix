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

  validates_numericality_of :position, {only_integer: true}

  def rating # This is a 'virtual attribute' for the queue_item model. For virtual attributes, we have to define the accessor methods ourselves (unlike with the actual attributes, which rails defines automatically).
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating) # Use 'update_column' rather than 'update_attributes' b/c we want to bypass the 'validates_presence_of :content' in 'review.rb'. We only are concerned about 'rating' here.
    else
      review = Review.new(user: user, video: video, rating: new_rating) # We can't use 'create' here. We must use 'new' b/c in the 'review.rb' model, we're validating the presence of 'content'.
      review.save(validate: false) # This will bypass validation in saving the review.
    end
  end

  def category_name
    category.name # It's this rather than 'video.category.name' b/c of the 'delegate' above.
  end

  private

  def review # In our 'queue_items_controller_spec.rb' rspec tests, we need to be sure to Fabricate each :queue_item with both a 'user' and a 'video'. Otherwise, their tests will fail (b/c of this method here which has both a 'user' and a 'video').
    @review ||= Review.where(user_id: user.id, video_id: video.id).first # We use memoization b/c the first time the 'review' method is called, it will go to the db and retrieve the record, but later if we call the record again, it will just get the value from the instance variable rather than hitting the db a second time.
  end
end

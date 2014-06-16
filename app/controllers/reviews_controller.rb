class ReviewsController < ApplicationController

  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params.merge!(user: current_user)) # This passes rspec ("creates a review associated with the video") b/c it immediately associates the created review with the/a video. Much better than 'Review.create(review_params)' which creates a review not associated with a video.
    if review.save                           # .merge! is a ruby method that keeps all the current key-value pairs of the first hash and tacks on any other key value pairs that the second one has.  If any keys are the same, .merge! will keep the first hash's key-values (using only #merge will keep the SECOND hash's key value pairs when a key is the same between the two).
      redirect_to @video
    else
      @reviews = @video.reviews.reload # When you do 'reload', Rails will load from the DB, so the invalid review (whose id = nil) will be thrown away.  This allows the 'sets @reviews' test in Rspec to pass.
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end

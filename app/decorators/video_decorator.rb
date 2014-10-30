class VideoDecorator < Draper::Decorator # The 'VideoDecorator' is just a wrapper that wraps around the video object here.  This allows us to take the logic out of the view and put it here.  This 'rating_average'
  delegate_all # This will call on the other methods on the Video model itself for the view template: We have to be able to pass through ALL the method calls that are not on the VideoDecorator to the actual video itself.

  def rating_average  # We access the wrapped object by using 'object' here; in this case 'object' represents '@video'
    object.rating_average > 0 ? "#{object.rating_average} / 5" : "No rating yet"
  end    # rating_average .. this method that we're using on 'object' comes from models/video.rb

end
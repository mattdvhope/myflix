module ApplicationHelper
  def options_for_video_reviews(selected=nil) # Used in videos/show.html.haml & queue_items/index/html/haml for rating the video.
    options_for_select([5,4,3,2,1].map {|number| [pluralize(number, "Star"), number]}, selected) # This 'selected' will determine which of the options will be selected.
  end
end

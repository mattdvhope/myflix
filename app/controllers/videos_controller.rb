class VideosController < ApplicationController

  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id])) # With this, we 'wrap' the @video object into a Decorator (the 'draper' gem provides the 'decorate' method).  See app/decorators/video_decorator.rb ; This allows us in views/videos/show.html.haml to set the 'Rating' to @video.rating_average ; the logic has been moved from the View to the decorator.
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

end


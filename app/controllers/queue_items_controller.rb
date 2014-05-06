class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.normalize_queue_item_positions # method extracted to user.rb model; # Need this here to make the "normalizes the remaining queue items" rspec test to pass; when a queue_item is deleted, the proper position numbers will be in place now.
    redirect_to my_queue_path
  end

  def update_queue
    begin # 'begin' & 'rescue' enable us to capture the exception and then rescue it--making the exception available for the flash[:error] and the 'redirect_to' method.
    update_queue_items # method below 'private'
    current_user.normalize_queue_item_positions # method extracted to user.rb model
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers."
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
                           # map(&:video) = map{|qi| qi.video}
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data| # 'params[:queue_items]' is an array of hashes that have id's and new positions.
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update_attributes!(position: queue_item_data["position"], rating: queue_item_data["rating"]) if queue_item.user == current_user # We no longer need the 'if' and '!' before this b/c the 'update_attributes!' will automatically raise an exception if it doesn't save; that exception will cause the whole transaction to rollback. Thus, the queue_items that were validly saved before will also roll back to their previous state.
      end
    end
  end
end

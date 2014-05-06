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
    redirect_to my_queue_path
  end

  def update_queue
    begin
      ActiveRecord::Base.transaction do
        params[:queue_items].each do |queue_item_data| # 'params[:queue_items]' is an array of hashes that have id's and new positions.
          queue_item = QueueItem.find(queue_item_data["id"])
          queue_item.update_attributes!(position: queue_item_data["position"]) # We no longer need the 'if' and '!' before this b/c the 'update_attributes!' will automatically raise an exception if it doesn't save; that will cause the whole transaction to rollback. Thus, the queue_items that were saved before will also roll back to their previous state.
        end
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers."
      redirect_to my_queue_path
      return # We need to manually 'return' to avoid a 'double-redirect' error.
    end
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
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

end

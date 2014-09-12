class Admin::VideosController < ApplicationController # The controller has a module which is 'admin' ; These will be automatically wired up to the routes and views according to convention.
  before_action :require_user
  before_action :require_admin # In the rails console, choose the user(s) you want as 'admin' and then type, > matt.update_column(:admin, true) to update that user's column to be true.

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params) # This is a model-backed form, so all the data for this video is hashed under the video hash-key, including the category_id
    if @video.save
      flash[:success] = "You have successfully added the video, '#{@video.title}.'"
      redirect_to new_admin_video_path
    else
      flash[:error] = "You cannot add this video. Please check the red errors below."
      render :new
    end
  end

  private

  def require_admin
    if !current_user.admin? # "If the current user is not an 'admin'..." ; This 'admin?' method is made available by the 'add_column' of 'admin' (boolean) to the 'users' table using a migration.
      flash[:error] = "You are not authorized to do that."
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, :category_id)
  end


end

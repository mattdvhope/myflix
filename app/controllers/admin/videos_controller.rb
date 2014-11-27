class Admin::VideosController < AdminsController  # The controller has a module which is 'admin' ; These will be automatically wired up to the routes and views according to convention. In this particular case though, we're making this controller a child of AdminsController rather than ApplicationController b/c AdminsController has the 'require_admin' & 'require_user' methods which are needed in more than one 'admin' controller.

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params) # This is a model-backed form, so all the data for this video is hashed under the video hash-key, including the category_id
    if @video.save
      flash[:success] = "You have successfully added the video, '#{@video.title}.'"
      redirect_to new_admin_video_path
    else
      flash[:error] = "You cannot add this video. Please check the red errors below."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, :category_id, :video_url)
  end

end

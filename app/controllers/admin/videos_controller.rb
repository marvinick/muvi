class Admin::VideosController < AdminsController
  before_filter :require_user

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)
    if @video.save
      flash[:success] = "You have added a video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash[:error] = "You cannot add this video. Please fix the issue first"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url)
  end
end
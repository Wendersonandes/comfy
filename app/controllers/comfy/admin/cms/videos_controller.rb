class Comfy::Admin::Cms::VideosController < Comfy::Admin::Cms::BaseController

  before_action :build_video,  :only => [:new, :create]
  before_action :load_video,   :only => [:show, :edit, :update, :destroy]

  def index
		@videos = @site.videos.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @video.save!
    flash[:success] = 'video created'
    redirect_to :action => :index, :id => @video
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create video'
    render :action => :new
  end

  def update
    @video.update_attributes!(video_params)
    flash[:success] = 'video updated'
    redirect_to :action => :index, :id => @video
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update video'
    render :action => :edit
  end

  def destroy
    @video.destroy
    flash[:success] = 'Event deleted'
    redirect_to :action => :index
  end

  def reorder
    (params[:comfy_cms_video] || []).each_with_index do |id, index|
      if (video = Comfy::Cms::Video.find_by_id(id))
        video.update_column(:position, index)
      end
    end
    head :ok
  end


protected

  def build_video
		@video = @site.videos.new(video_params)
  end

  def load_video
    @video = @site.videos.find(params[:id])
		rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Event not found'
    redirect_to :action => :index
  end

  def video_params
    params.fetch(:video, {}).permit!
  end
end

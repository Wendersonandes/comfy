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
    respond_to do |format|
      if @video.save
        format.html { redirect_to :action => :index, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
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

	def get_videos_from_youtube
		saved_videos_from_youtube = @site.videos.where("youtube_id IS NOT NULL").pluck(:youtube_id)
		channel = Yt::Channel.new(:id => @site.youtube_profile)
		channel_videos = channel.videos.map { |vid| {
																						:youtube_id => vid.id, 
																						:title => vid.title,
																						:description => vid.description, 
																						:short_description => vid.description.truncate(75), 
																						:thumbnail => vid.snippet.thumbnails["default"]["url"]} }

		@videos = channel_videos.reject { |h| saved_videos_from_youtube.include?(h[:youtube_id]) }

    respond_to do |format|
			format.json { render :json => @videos, status: :created  }
		end

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

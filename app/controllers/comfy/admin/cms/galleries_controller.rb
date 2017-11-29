class Comfy::Admin::Cms::GalleriesController < Comfy::Admin::Cms::BaseController

  before_action :build_gallery,  :only => [:new, :create]
  before_action :load_gallery,   :only => [:show, :edit, :update, :destroy]

  def index
		@galleries = @site.galleries.page(params[:page])
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
    @gallery.save!
    flash[:success] = 'Gallery created'
    redirect_to :action => :index, :id => @gallery
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Gallery'
    render :action => :new
  end

  def update
    @gallery.update_attributes!(gallery_params)
    flash[:success] = 'Gallery updated'
    redirect_to :action => :index, :id => @gallery
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Gallery'
    render :action => :edit
  end

  def destroy
    @gallery.destroy
    flash[:success] = 'Gallery deleted'
    redirect_to :action => :index
  end

  def reorder
    (params[:comfy_cms_gallery] || []).each_with_index do |id, index|
      if (gallery = Comfy::Cms::Gallery.find_by_id(id))
        gallery.update_column(:position, index)
      end
    end
    head :ok
  end


protected

  def build_gallery
		@gallery = @site.galleries.new(gallery_params)
  end

  def load_gallery
    @gallery = @site.galleries.find(params[:id])
		rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Gallery not found'
    redirect_to :action => :index
  end

  def gallery_params
    params.fetch(:gallery, {}).permit!
  end
end

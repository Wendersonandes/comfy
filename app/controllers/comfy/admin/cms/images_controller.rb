class Comfy::Admin::Cms::ImagesController < Comfy::Admin::Cms::BaseController

  before_filter :load_gallery
  before_action :build_image,  :only => [:new, :create]
  before_action :load_image,   :only => [:show, :edit, :update, :destroy]

  def index
		@images = @gallery.images.page(params[:page])
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
    @image.save!
    flash[:success] = 'Image created'
    redirect_to :action => :index, :id => @image
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Image'
    render :action => :new
  end

  def update
    @image.update_attributes!(image_params)
    flash[:success] = 'Image updated'
    redirect_to :action => :index, :id => @image
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Image'
    render :action => :edit
  end

  def destroy
    @image.destroy
    flash[:success] = 'Image deleted'
    redirect_to :action => :index
  end

  def reorder
    (params[:comfy_cms_image] || []).each_with_index do |id, index|
			if (image = @gallery.images.find(id))
        image.update_column(:row_order, index)
      end
    end
    head :ok
  end


protected

  def load_gallery
		@gallery = @site.galleries.find(params[:gallery_id])
  end

  def build_image
    @image = @gallery.images.new(image_params)
  end

  def load_image
    @image = @gallery.images.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Image not found'
      redirect_to :action => :index
  end

  def image_params
    params.fetch(:image, {}).permit!
  end
end

class Comfy::Admin::Cms::SlidesController < Comfy::Admin::Cms::BaseController

  skip_before_filter :load_fixtures

  before_filter :build_slide,  :only => [:new, :create]
  before_filter :load_slide,   :only => [:edit, :update, :destroy]

  def index
    @slides = @site.slides.order('comfy_cms_slides.position')

      if params[:ajax]
      slides = @slides.images.collect do |slide|
        { :thumb  => slide.file.url(:cms_thumb),
          :image  => slide.file.url }
      end
      render :json => slides
    else
      return redirect_to :action => :new if @site.slides.count == 0
    end
  end

  def new
    render
  end

  def create
    @slide.save!

    case params[:source]
    when 'plupload'
      render :body => render_to_string(:partial => 'slide', :object => @slide)
    when 'redactor'
      render :json => {:filelink => @slide.file.url, :filename => @slide.label}
    else
      flash[:success] = I18n.t('comfy.admin.cms.files.created')
      redirect_to :action => :edit, :id => @slide
    end

  rescue ActiveRecord::RecordInvalid
    case params[:source]
    when 'plupload'
      render :body => @slide.errors.full_messages.to_sentence, :status => :unprocessable_entity
    when 'redactor'
      render body: nil, :status => :unprocessable_entity
    else
      flash.now[:danger] = I18n.t('comfy.admin.cms.files.creation_failure')
      render :action => :new
    end
  end

  def update
    @slide.update(file_params)
    flash[:success] = I18n.t('cms.slides.updated')
    redirect_to :action => :edit, :id => @slide
  rescue ActiveRecord::RecordInvalid
    logger.detailed_error($!)
    flash.now[:error] = I18n.t('cms.slides.update_failure')
    render :action => :edit
  end

  def destroy
    @slide.destroy
    respond_to do |format|
      format.js
      format.html do
        flash[:success] = I18n.t('cms.slides.deleted')
        redirect_to :action => :index
      end
    end
  end

  def reorder
    (params[:cms_slide] || []).each_with_index do |id, index|
      if (cms_slide = Comfy::Cms::Slide.find_by_id(id))
        cms_slide.update_attributes(:position => index)
      end
    end
    head :ok
  end

protected

  def build_slide
    @slide = @site.slides.new(file_params)
  end

  def load_slide
    @slide = @site.slides.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = I18n.t('cms.slides.not_found')
    redirect_to :action => :index
  end

  def file_params
    file = params[:file]
    unless file.is_a?(Hash) || file.respond_to?(:to_unsafe_hash)
      params[:file] = { }
      params[:file][:file] = file
    end
    params.fetch(:file, {}).permit!
  end
end

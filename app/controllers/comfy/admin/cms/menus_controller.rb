class Comfy::Admin::Cms::MenusController < Comfy::Admin::Cms::BaseController
  before_filter :build_menu, :only => [:new, :create]
  before_filter :load_menu,  :only => [:edit, :update, :destroy]

  def index
    return redirect_to :action => :new if @site.menus.count == 0
    @menus = @site.menus
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @menu.save!
    flash[:success] = I18n.t('comfy.admin.cms.menus.created')
    redirect_to :action => :index
    rescue ActiveRecord::RecordInvalid
      logger.detailed_error($!)
      flash.now[:error] = I18n.t('comfy.admin.cms.menus.creation_failure')
      render :action => :new
  end

  def update
    @menu.update_attributes!(menu_params)
    flash[:success] = I18n.t('comfy.admin.cms.menus.updated')
    redirect_to :action => :index, :id => @menu
  rescue ActiveRecord::RecordInvalid
    logger.detailed_error($!)
    flash.now[:error] = I18n.t('comfy.admin.cms.menus.update_failure')
    render :action => :index
  end

  def destroy
    @menu.destroy
    flash[:success] = I18n.t('comfy.admin.cms.menus.deleted')
    redirect_to :action => :index
  end

	def reorder
    (params[:comfy_cms_menu] || []).each_with_index do |id, index|
      if (cms_file = ::Comfy::Cms::Menu.find_by_id(id))
        cms_file.update_column(:position, index)
      end
    end
    head :ok
  end

   
protected
    
	def build_menu
		@menu= @site.menus.new(menu_params)
	end

	def load_menu
			@menu = @site.menus.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			flash[:error] = I18n.t('comfy.admin.cms.menus.not_found')
			redirect_to :action => :index
	end
	
  def menu_params
    params.fetch(:menu, {}).permit!
  end

end

class Comfy::Admin::Cms::MenuItemsController < Comfy::Admin::Cms::BaseController
  before_filter :load_menu
  before_filter :build_menu_item, :only => [:new, :create]
  before_filter :load_menu_item,  :only => [:edit, :update, :destroy]

  def index
    return redirect_to :action => :new if @menu.menu_items.count == 0
    @menu_items = @menu.menu_items
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @menu_item.save!
    flash[:success] = I18n.t('comfy.admin.cms.menu_items.created')
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    logger.detailed_error($!)
    flash.now[:error] = I18n.t('comfy.admin.cms.menu_items.creation_failure')
    render :action => :new
  end

  def update
    @menu_item.update_attributes!(menu_item_params)
    flash[:success] = I18n.t('comfy.admin.cms.menu_items.updated')
    redirect_to :action => :index, :id => @menu_item
  rescue ActiveRecord::RecordInvalid
    logger.detailed_error($!)
    flash.now[:error] = I18n.t('comfy.admin.cms.menu_items.update_failure')
    render :action => :edit
  end

  def destroy
    @menu_item.destroy
    flash[:success] = I18n.t('comfy.admin.cms.menu_items.deleted')
    redirect_to :action => :index
  end

  def reorder
    (params[:comfy_cms_menu_item] || []).each_with_index do |id, index|
      if (cms_file = ::Comfy::Cms::MenuItem.find_by_id(id))
        cms_file.update_column(:position, index)
      end
    end
    head :ok
  end

    
protected

  def load_menu
    @menu = @site.menus.find(params[:menu_id]) || session[:menu_id]
  end
    
  def build_menu_item
    @menu_item= @menu.menu_items.new(menu_item_params)
  end
  
  def load_menu_item
    @menu_item = @menu.menu_items.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t('comfy.admin.cms.menu_items.not_found')
      redirect_to :action => :index
  end
	def menu_item_params
		params.fetch(:menu_item, {}).permit!
	end

end

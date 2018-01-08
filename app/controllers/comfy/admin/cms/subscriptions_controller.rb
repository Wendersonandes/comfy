class Comfy::Admin::Cms::SubscriptionsController < Comfy::Admin::Cms::BaseController

  before_action :build_subscription,  :only => [:new, :create]
  before_action :load_subscription,   :only => [:show, :edit, :update, :destroy]

  def index
		@subscriptions = @site.subscriptions.page(params[:page])
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
      if @subscription.save
        format.html { redirect_to :action => :index, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @subscription.update_attributes!(subscription_params)
    flash[:success] = 'subscription updated'
    redirect_to :action => :index, :id => @subscription
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update subscription'
    render :action => :edit
  end

  def destroy
    @subscription.destroy
    flash[:success] = 'Event deleted'
    redirect_to :action => :index
  end

  def reorder
    (params[:comfy_cms_subscription] || []).each_with_index do |id, index|
      if (subscription = Comfy::Cms::Subscription.find_by_id(id))
        subscription.update_column(:position, index)
      end
    end
    head :ok
  end


protected

  def build_subscription
		@subscription = @site.subscriptions.new(subscription_params)
  end

  def load_subscription
    @subscription = @site.subscriptions.find(params[:id])
		rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Event not found'
    redirect_to :action => :index
  end

  def subscription_params
    params.fetch(:subscription, {}).permit!
  end
end

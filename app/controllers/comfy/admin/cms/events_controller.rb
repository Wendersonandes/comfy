class Comfy::Admin::Cms::EventsController < Comfy::Admin::Cms::BaseController

  before_action :build_event,  :only => [:new, :create]
  before_action :load_event,   :only => [:show, :edit, :update, :destroy]

  def index
		@events = @site.events.page(params[:page])
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
    @event.save!
    flash[:success] = 'Event created'
    redirect_to :action => :index, :id => @event
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Event'
    render :action => :new
  end

  def update
    @event.update_attributes!(event_params)
    flash[:success] = 'Event updated'
    redirect_to :action => :index, :id => @event
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Event'
    render :action => :edit
  end

  def destroy
    @event.destroy
    flash[:success] = 'Event deleted'
    redirect_to :action => :index
  end

  def reorder
    (params[:event] || []).each_with_index do |id, index|
      if (event = Comfy::Cms::Event.find_by_id(id))
        event.update_column(:position, index)
      end
    end
    head :ok
  end


protected

  def build_event
		@event = @site.events.new(event_params)
  end

  def load_event
    @event = @site.events.find(params[:id])
		rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Event not found'
    redirect_to :action => :index
  end

  def event_params
    params.fetch(:event, {}).permit!
  end
end

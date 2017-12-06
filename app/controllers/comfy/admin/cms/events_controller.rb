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
    respond_to do |format|
      if @event.save
        format.html { redirect_to :action => :index, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
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
    (params[:comfy_cms_event] || []).each_with_index do |id, index|
      if (event = Comfy::Cms::Event.find_by_id(id))
        event.update_column(:position, index)
      end
    end
    head :ok
  end

	def get_facebook_events
		user_auth = current_user.authentications.find_by_provider('facebook')
		user_token = user_auth.token
		graph = Koala::Facebook::API.new(user_token)
		events_facebook = graph.get_object("#{@site.facebook_profile}/events")
		saved_events_facebook_ids = @site.events.where("facebook_id IS NOT NULL").pluck(:facebook_id)
		@events = events_facebook.reject { |h| saved_events_facebook_ids.include?(h["id"]) }
    respond_to do |format|
			format.json { render :json => @events, status: :created  }
		end
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

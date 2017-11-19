class Comfy::Cms::Event < ActiveRecord::Base
  self.table_name = 'comfy_cms_events'

  # -- Validations ----------------------------------------------------------
  validates :site_id, :presence   => true
	validates :start, :presence => true
	validates :title, :presence => true

  # -- Relationships --------------------------------------------------------
  belongs_to :site

  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_events.position') }

  def assign_position
    max = Comfy::Cms::Event.maximum(:position)
    self.position = max ? max + 1 : 0
  end

end

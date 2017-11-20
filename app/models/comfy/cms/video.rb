class Comfy::Cms::Video < ActiveRecord::Base
  self.table_name = 'comfy_cms_videos'

  # -- Validations ----------------------------------------------------------
  validates :site_id, :presence   => true
	validates :url, :presence => true

  # -- Relationships --------------------------------------------------------
  belongs_to :site

  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_videos.position') }

  def assign_position
    max = Comfy::Cms::Video.maximum(:position)
    self.position = max ? max + 1 : 0
  end

end

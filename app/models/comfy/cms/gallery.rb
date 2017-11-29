class Comfy::Cms::Gallery < ActiveRecord::Base
  self.table_name = 'comfy_cms_galleries'

  # -- Validations ----------------------------------------------------------
  validates :site_id, :presence   => true
	validates :title, :presence => true

  # -- Relationships --------------------------------------------------------
  belongs_to :site
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position
	after_save				:set_all_others_unfeatured

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_galleries.position') }
  scope :published, -> { where(:is_published => true) }
  scope :featured, -> { where(:is_featured => true) }

  def assign_position
    max = Comfy::Cms::Gallery.maximum(:position)
    self.position = max ? max + 1 : 0
  end

	def set_all_others_unfeatured
		if self.is_featured
			Comfy::Cms::Gallery.where('id != ? and is_featured and site_id = ?', self.id, self.site_id).update_all("is_featured = 'false'")
		end
	end

end

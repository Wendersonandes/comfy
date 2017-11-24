require 'video_thumb'

class Comfy::Cms::Video < ActiveRecord::Base
  self.table_name = 'comfy_cms_videos'

  # -- Validations ----------------------------------------------------------
  validates :site_id, :presence   => true
	validates :url, :presence => true

  # -- Relationships --------------------------------------------------------
  belongs_to :site

  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position
	after_save				:set_all_others_unfeatured

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_videos.position') }
  scope :published, -> { where(:is_published => true) }
  scope :featured, -> { where(:is_featured => true) }

  def assign_position
    max = Comfy::Cms::Video.maximum(:position)
    self.position = max ? max + 1 : 0
  end

	def video_thumb(size = nil)
		VideoThumb::get(self.url, size)
	end

	def set_all_others_unfeatured
		if self.is_featured
			Comfy::Cms::Video.where('id != ? and is_featured and site_id = ?', self.id, self.site_id).update_all("is_featured = 'false'")
		end
	end

end

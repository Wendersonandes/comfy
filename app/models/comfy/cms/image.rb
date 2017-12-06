class Comfy::Cms::Image < ActiveRecord::Base

	include ImageUploader::Attachment.new(:file)

  self.table_name = 'comfy_cms_images'

  # -- Relationships --------------------------------------------------------
  belongs_to :gallery
  has_one :site, :through => :gallery
  
  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_images.row_order') }
	scope :trashed, -> {where(:is_trashed => true)}
	scope :no_trashed, -> {where(:is_trashed => false)}
protected

end

class Comfy::Cms::Slide < ActiveRecord::Base
  self.table_name = 'comfy_cms_slides'

  IMAGE_MIMETYPES = %w(gif jpeg pjpeg png svg+xml tiff).collect{|subtype| "image/#{subtype}"}

  attr_accessor :dimensions

  # -- Relationships --------------------------------------------------------
  belongs_to :site

  # -- Callbacks ------------------------------------------------------------
  before_create :assign_position

  # -- AR Extensions --------------------------------------------------------
  has_attached_file :file, ComfortableMexicanSofa.config.upload_file_options.merge(
    # dimensions accessor needs to be set before file assignment for this to work
    :styles => lambda { |f|
      if f.respond_to?(:instance) && f.instance.respond_to?(:dimensions)
        (f.instance.dimensions.blank?? { } : { :original => f.instance.dimensions }).merge(
          :cms_thumb => '80x60#'
        ).merge(ComfortableMexicanSofa.config.upload_file_options[:styles] || {})
      end
    }
  )

  before_post_process :is_image?

  # -- Validations ----------------------------------------------------------
  validates :site_id, :presence => true
	validates_attachment_presence :file
  do_not_validate_attachment_file_type :file

  # -- Instance Methods -----------------------------------------------------
  def is_image?
    IMAGE_MIMETYPES.include?(file_content_type)
  end

protected

  def assign_position
    max = Comfy::Cms::Slide.maximum(:position)
    self.position = max ? max + 1 : 0
  end
end

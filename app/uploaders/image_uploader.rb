require "image_processing/mini_magick"

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :determine_mime_type
  plugin :remote_url, max_size: 20*1024*1024
  plugin :remove_attachment
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :versions
  plugin :module_include

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion ['image/jpeg', 'image/png', 'image/gif']
  end

  def process(io, context)
    case context[:phase]
    when :store
      thumb = resize_to_limit!(io.download,250,300)
      email_thumb = resize_to_fill!(io.download,240,160)
      { original: io, thumb: thumb, email_thumb: email_thumb }
    end
  end
end

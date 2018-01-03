require "active_model_serializers"
class ImageSerializer < ActiveModel::Serializer
  attributes :id
	attributes :image_thumb_url

	def image_thumb_url
		object.file_url(:thumb)
	end
end

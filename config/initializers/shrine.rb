require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
	cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
	store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
}

Shrine.plugin :activerecord
Shrine.plugin :logging, logger: Rails.logger
Shrine.plugin :backgrounding

Shrine::Attacher.promote { |data| UploadJob.perform_async(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_async(data) }
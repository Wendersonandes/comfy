require 'sucker_punch'
class UploadJob
  include SuckerPunch::Job

  def perform(data)
    Shrine::Attacher.promote(data)
  end
end

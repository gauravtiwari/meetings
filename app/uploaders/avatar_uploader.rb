class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mini do
    process :resize_to_fill => [50, 50]
  end
end

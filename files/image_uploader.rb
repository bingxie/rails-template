class ImageUploader < CarrierWave::Uploader::Base
  storage :qiniu

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    variable = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(variable) or model.instance_variable_set(variable, SecureRandom.uuid)
  end
end

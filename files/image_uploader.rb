class ImageUploader < CarrierWave::Uploader::Base
  storage :qiniu

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    random_filename if super.present?
  end

  private

  def random_filename
    @prefix ||= SecureRandom.uuid.delete('-')
    "#{@prefix}.#{file.extension.downcase}"
  end
end

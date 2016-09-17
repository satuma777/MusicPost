module CarrierWave
  module RMagick
    attr_reader :content_type

    def set_content_type
      image = Magick::Image.read(current_path).shift
      @content_type = { mimetype: image.mimetype }
    end
  end
end
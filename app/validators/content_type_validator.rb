class ImageSizeValidator < ActiveModel::EachValidator
  OPTIONS = {
    width: {
      field:    :width,
      function: :'==',
      message:  'invalid_image_width'
    }
  }.freeze
 
  def validate_each(object, attribute, value)
    return if value.nil? || value.dimension.nil?
 
    dimension = value.dimension
    options.each do |key, val|
      next unless OPTIONS.key? key
      check = OPTIONS[key]
      unless dimension[check[:field]].send check[:function], val
        object.errors[attribute] << (options[:message] || I18n.t("activerecord.errors.messages.#{check[:message]%[val]}"))
      end
    end
  end
end
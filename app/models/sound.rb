class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    validates :title, presence: true
    validates :content, presence: true
end

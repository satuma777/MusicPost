class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    validates :name, presence: true
    validates :content, presence: true
    validates :content_type_check
    validates :content_type_check

    def content_type_check
      if date.present? && date < Date.today
        #↑nil, "", " "(半角スペースのみ), [](空の配列), {}(空のハッシュ) のときにfalseを返します。
        errors.add(:date, ": 過去の日付は使用できません")
      end
    end
end

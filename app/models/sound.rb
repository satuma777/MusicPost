class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    validates :title, presence: true
    validates :content, presence: true
    validate :check_sound

    def extension_white_list
      %w(mp3 wav ogg)
    end

    def check_sound
    if upfile != nil
        if !perms.include?(File.extname(self.upfile).downcase) then
            errors.add(:upfile, "投稿できるのは、mp3、ogg、wavのみです。")
        elsif MimeMagic.by_magic(file) != "audio/mp3" && MimeMagic.by_magic(file) != "audio/mpeg" && MimeMagic.by_magic(file) != "audio/wav" && MimeMagic.by_magic(file) != "audio/x-wav" && MimeMagic.by_magic(file) != "audio/ogg" && MimeMagic.by_magic(file) != "video/ogg" && MimeMagic.by_magic(file) != "audio/mpeg" then
             errors.add(:upfile, "不正なファイルです。")
        else file.size > 15.megabyte
            errors.add(:upfile, "ファイルサイズは15MBまでです。")
        end
    end
    end

    if !file.nil?
        file_name = file_name.kconv(Kconv::SJIS, Kconv::UTF8)
        File.open("public/files/#{file_name}", 'wb') { |f| f.write(file.read) }
        @self.upfile = file_name
    end
end

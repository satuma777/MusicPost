class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    validates :title, presence: true
    validates :content, presence: true
    validate :check_sound

    def extension_white_list
      %w(mp3 wav ogg)
      #↑%w(mp3 wav ogg)は['mp3', 'ogg', 'wav']と等価です。
    end

    def check_sound
    if upfile != nil
        white_list = extension_white_list
        file_name = upfile.original_filename
        if !white_list.include?(File.extname(file_name).downcase) then
            errors.add(:upfile, "投稿できるのは、mp3、ogg、wavのみです。")
        elsif MimeMagic.by_magic(upfile) != "audio/mp3" && MimeMagic.by_magic(upfile) != "audio/mpeg" && MimeMagic.by_magic(upfile) != "audio/wav" && MimeMagic.by_magic(file) != "audio/x-wav" && MimeMagic.by_magic(upfile) != "audio/ogg" && MimeMagic.by_magic(upfile) != "video/ogg" && MimeMagic.by_magic(upfile) != "audio/mpeg" then
             errors.add(:upfile, "不正なファイルです。")
        else file.size > 15.megabyte
            errors.add(:upfile, "ファイルサイズは15MBまでです。")
        end
    end
    end

    def set_sound(file)
        if !file.nil?
            file_name = file.original_filename
            file_name = file_name.kconv(Kconv::SJIS, Kconv::UTF8)
            File.open("public/files/#{file_name}", 'wb') { |f| f.write(file.read) }
            self.upfile = file_name
        end
    end
end

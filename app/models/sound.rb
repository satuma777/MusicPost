class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    validates :title, presence: true
    validates :content, presence: true
    validate :check_sound

     def check_sound
        if upfile != nil
            if upfile == "ext_error" then
                errors[:base] << "投稿できるのは、mp3、ogg、wavのみです。"
            elsif upfile == "file_error" then
                 errors[:base] << "不正なファイルです。"
            elsif upfile == "size_error" then
                errors[:base] << "ファイルサイズは15MBまでです。"
            end
        end
    end

    def set_sound(file)
            file_name = file.original_filename
            file_name = file_name.kconv(Kconv::SJIS, Kconv::UTF8)
            File.open("public/files/#{file_name}", 'wb') { |f| f.write(file.read) }
            self.upfile = file_name
    end
end

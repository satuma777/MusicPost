class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    mount_uploader :image, ImageUploader

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
            file_orgname = file.original_filename
            #↑コントローラー側で定義されているfile_orgnameとは別物。
            file_orgname = file_orgname.kconv(Kconv::SJIS, Kconv::UTF8)
            #file_name = SecureRandom.hex(10) + self.id.to_s
            file_name = 'sid' + self.object_id.to_s
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            puts('ファイル名'+file_name)
            File.open("app/assets/sounds/upfiles/#{file_name}", 'wb') { |f| f.write(file.read) }
            self.upfile = file_orgname
            self.path = file_name
            self.ext_name = File.extname(file_orgname).downcase
    end
end

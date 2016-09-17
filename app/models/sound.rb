class Sound < ActiveRecord::Base
    validate :upfile_check
    validate :image_check

    validate :title_check
    validate :content_check

    def title_check
        if title.empty?
            errors.add(:title, "タイトルを入力してください。")
        end
    end

    def content_check
        if content.empty?
            errors.add(:content, "音楽の説明を入力してください。")
        end
    end

    def upfile_check
        if upfile != nil
            if upfile == "ext_error" then
                errors[:upfile] << "投稿できるのは、mp3、ogg、wavのみです。"
            elsif upfile == "file_error" then
                 errors[:upfile] << "不正なファイル形式です。"
            elsif upfile == "size_error" then
                errors[:upfile] << "ファイルサイズは15MBまでです。"
            end
        else
            errors[:upfile] <<"アップロードする音声ファイルを選択してください。"
        end
    end

    def image_check
        if image != nil
            if image == "ext_error" then
                errors[:image] << "投稿できるのは、jpg、jpeg、gif、pngのみです。"
            elsif image == "file_error" then
                 errors[:image] << "不正なファイル形式です。"
            elsif image == "size_error" then
                errors[:image] << "ファイルサイズは1MBまでです。"
            end
        else
            errors[:image] <<"サムネイルを選択してください。"
        end
    end

    def set_sound(file)
            file_orgname = file.original_filename
            #↑コントローラー側で定義されているfile_orgnameとは別物。
            file_orgname = file_orgname.kconv(Kconv::SJIS, Kconv::UTF8)
            #file_name = SecureRandom.hex(10) + self.id.to_s
            file_name = 'sid' + self.object_id.to_s + File.extname(file_orgname).downcase
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            File.open("public/uploads/sounds/sound/#{self.id}/#{file_name}", 'wb') { |f| f.write(file.read) }
            self.upfile = file_orgname
            self.path = file_name
            self.ext_name = File.extname(file_orgname).downcase
            #↑HTMLでの再生の際は、pathとext_nameを組み合わせて、～.mp3のような名前にし、再生できる形にする。
    end
    def set_image(file)
            file_orgname = file.original_filename
            #↑コントローラー側で定義されているfile_orgnameとは別物。
            file_orgname = file_orgname.kconv(Kconv::SJIS, Kconv::UTF8)
            #file_name = SecureRandom.hex(10) + self.id.to_s
            file_name = 'img' + self.object_id.to_s + File.extname(file_orgname).downcase
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            File.open("public/uploads/sounds/image/#{self.id}/#{file_name}", 'wb') { |f| f.write(file.read) }
            self.image = file_orgname
            #↑HTMLでの再生の際は、pathとext_nameを組み合わせて、～.mp3のような名前にし、再生できる形にする。
    end
end

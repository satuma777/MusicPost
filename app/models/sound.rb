class Sound < ActiveRecord::Base
    @@sound_init = "sid"
    @@image_init = "img"
    @@image_s = "_s"
    #↑@@でクラス変数を定義。

    require 'RMagick'
    require "fileutils"

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

    def set_sound(file, file_id, id)
        if !file.nil?
            file_org_name = file.original_filename
            #↑コントローラー側で定義されているfile_orgnameとは別物。
            file_org_name = file_org_name.kconv(Kconv::SJIS, Kconv::UTF8)
            #file_name = SecureRandom.hex(10) + self.id.to_s
            file_name = @@sound_init.to_s + file_id.to_s
             full_file_name = file_name + File.extname(file_org_name).downcase
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            folder = "./public/uploads/sounds/" + file_id.to_s + "/sound"
            #↑通常、一番前の"."（ドット）はいらないが、"FileUtils"を使う時は必要。
            FileUtils.mkdir_p(folder)
            File.open("#{folder}/#{ full_file_name}", 'wb') { |f| f.write(file.read) }  rescue nil
            self.upfile = file_org_name
            self.ext_name = File.extname(file_org_name).downcase
            #↑HTMLでの再生の際は、pathとext_nameを組み合わせて、～.mp3のような名前にし、再生できる形にする。
        end
    end
    def set_image(file, file_id, id)
         if !file.nil?
            org_img = file.read
            #↑read メソッドを呼ぶと，バイナリ（元のデータ、ここでは画像ファイル）が取得できる，一度呼ぶと取得できなくなる．
            #↑そのため、readで一度バイナリを取得したら何かの変数に入れておく。
            
            edit_img = Magick::Image.from_blob(org_img).shift
            normal_img = create_square_thumbnail(edit_img, 500).to_blob
            small_img = create_square_thumbnail(edit_img, 200).to_blob

            file_org_name = file.original_filename
            #↑コントローラー側で定義されているfile_orgnameとは別物。
            file_org_name = file_org_name.kconv(Kconv::SJIS, Kconv::UTF8)
            #file_name = SecureRandom.hex(10) + self.id.to_s
            file_name = @@image_init.to_s + file_id.to_s
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            file_s_name = file_name + @@image_s.to_s
            full_file_name = file_name + File.extname(file_org_name).downcase
            full_file_s_name = file_s_name + File.extname(file_org_name).downcase
            folder = "./public/uploads/sounds/" + file_id.to_s + "/thumbnail"
            #↑通常、一番前の"."（ドット）はいらないが、"FileUtils"を使う時は必要。
            FileUtils.mkdir_p(folder)
            File.open("#{folder}/#{full_file_name}", 'wb') { |f| f.write(normal_img) }  rescue nil
            File.open("#{folder}/#{full_file_s_name}", 'wb') { |f| f.write(small_img) }  rescue nil
            self.image = file_org_name
            self.img_ext_name = File.extname(file_org_name).downcase
        end
    end

    private
    def create_square_thumbnail(rmagick, size)
          narrow = rmagick.columns > rmagick.rows ? rmagick.rows : rmagick.columns
          rmagick.crop(Magick::CenterGravity, narrow, narrow).resize(size, size)
    end
end

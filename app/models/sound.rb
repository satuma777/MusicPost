#↓"Settings."の付いたものは、/config/の"settings.yml"で定義している定数を表す。

class Sound < ActiveRecord::Base
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
        if upfile != ""
            if upfile == "ext_error" then
                errors[:upfile] << "アップロードできるのは、mp3、ogg、wavのみです。"
            elsif upfile == "file_error" then
                 errors[:upfile] << "不正なファイル形式です。mp3、ogg、wavどれかのファイル形式にしてください。"
            elsif upfile == "size_error" then
                errors[:upfile] << "ファイルサイズは" + Settings.SOUND_DATA_SIZE.to_s + "MBまでです。"
            end
        else
            errors[:upfile] <<"アップロードする音声ファイルを選択してください。"
        end
    end

    def image_check
        if image != ""
            if image == "ext_error" then
                errors[:image] << "アップロードできるのは、jpg、jpeg、gif、pngのみです。"
            elsif image == "file_error" then
                 errors[:image] << "不正なファイル形式です。jpg、jpeg、gif、pngどれかのファイル形式にしてください。"
            elsif image == "size_error" then
                errors[:image] << "ファイルサイズは" + Settings.IMAGE_DATA_SIZE.to_s + "MBまでです。"
            end
        else
            errors[:image] <<"サムネイルを選択してください。"
        end
    end

    def upload_sound(sound_file, sound_org_name)
         if !sound_file.nil?

            #デバッグ
            logger.debug "sound_@sound.path="
            logger.debug(self.path)
            #デバッグ

            #file_name = SecureRandom.hex(10) + self.id.to_s
            new_file_name = Settings.SOUND_HEAD_NAME.to_s + self.path.to_s + File.extname(sound_org_name).downcase
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            new_folder = "./public/uploads/sounds/" + self.path.to_s + "/sound"
            #↑通常、一番前の"."（ドット）はいらないが、"FileUtils"を使う時は必要。
            FileUtils.mkdir_p(new_folder)

            #デバッグ
            logger.debug "sound_cur_folder_path=" 
            logger.debug(new_folder)
            #デバッグ

            File.open("#{new_folder}/#{new_file_name}", 'wb') { |f| f.write(sound_file.read) }
            self.upfile = sound_org_name
            self.ext_name = File.extname(sound_org_name).downcase
            #↑HTMLでの再生の際は、pathとext_nameを組み合わせて、～.mp3のような名前にし、再生できる形にする。
        end
    end

    def upload_image(img_file, img_org_name)

         #デバッグ
         logger.debug "img_@sound.path=" 
         logger.debug(self.path)
         #デバッグ

         if !img_file.nil?

            #デバッグ
            logger.debug "img_@sound.path=" 
            logger.debug(self.path)
            #デバッグ

            org_img = img_file.read
            #↑read メソッドを呼ぶと，バイナリ（元のデータ、ここでは画像ファイル）が取得できる，一度呼ぶと取得できなくなる．
            #↑そのため、readで一度バイナリを取得したら何かの変数に入れておく。
            edit_img = Magick::Image.from_blob(org_img).shift
            #↑rmagicにファイルを読み込ませる。
            normal_img = create_square_thumbnail(edit_img, Settings.NORMAL_IMAGE_SIZE).to_blob
            small_img = create_square_thumbnail(edit_img, Settings.SMALL_IMAGE_SIZE).to_blob

            file_name = Settings.IMAGE_HEAD_NAME.to_s + self.path.to_s
            #↑idを取得するときは、.idではなく、.object_idと書く。to_sで文字列（string型）に直している。
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            new_file_name = file_name + File.extname(img_org_name).downcase
            new_file_s_name = file_name + Settings.SMALL.to_s + File.extname(img_org_name).downcase

            new_folder = "./public/uploads/sounds/" + self.path.to_s + "/thumbnail"
            #↑通常、一番前の"."（ドット）はいらないが、"FileUtils"を使う時は必要。
            FileUtils.mkdir_p(new_folder)

            #デバッグ
            logger.debug "img_cur_folder_path="
            logger.debug(new_folder)
            #デバッグ

            File.open("#{new_folder}/#{new_file_name}", 'wb') { |f| f.write(normal_img) }
            File.open("#{new_folder}/#{new_file_s_name}", 'wb') { |f| f.write(small_img) }
            self.image = img_org_name
            self.img_ext_name = File.extname(img_org_name).downcase
        end
    end

    private
    def create_square_thumbnail(rmagick, size)
          narrow = rmagick.columns > rmagick.rows ? rmagick.rows : rmagick.columns
          rmagick.crop(Magick::CenterGravity, narrow, narrow).resize(size, size)
    end
end

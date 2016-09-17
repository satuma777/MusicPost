class Sound < ActiveRecord::Base
    #mount_uploader :sound, SoundUploader
    has_attached_file :image, :url =>  "/:class/:attachment/:id/:style_:filename",
                                :default_url => "images/default.jpg",
                                            :styles => { :normal => "100x100#", :large => '200x200#' },
                                            :storage => :filesystem,
                                            :whiny => false
    validates_attachment_content_type :image, content_type:  ["image/jpeg", "image/gif", "image/png"]
    validates :title, presence: true
    validates :content, presence: true
    validate :check_sound


     def check_sound
        if upfile != nil 
            if upfile == "ext_error" then
                errors[:base] << "投稿できるのは、mp3、ogg、wavのみです。"
            elsif upfile == "file_error" then
                 errors[:base] << "ファイル形式が不正です。"
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
            #↑.object_idは各オブジェクトに対して一意な整数を返す。オブジェクトとは、インスタンスもクラスも含めた一つ一つのものである。
            #↑インスタンスもオブジェクトなので、オブジェクト1つ1つに対しても一意なidが返される。
            puts('ファイル名'+file_name)
            File.open("public/uploads/sound/sound/#{file_name}", 'wb') { |f| f.write(file.read) }
            self.upfile = file_orgname
            self.path = file_name
            #↑HTMLでの再生の際は、pathとext_nameを組み合わせて、～.mp3のような名前にし、再生できる形にする。
    end

protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end

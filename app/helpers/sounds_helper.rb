module SoundsHelper
    def image_for(sound)
        if sound.img_path
          # image_tagを用いてuserのプロフィール画像を表示してください
          #normal_path = sound.img_path.to_s + sound.img_ext_name.to_s
          thumb_path = sound.img_path.to_s + "_thumb" + sound.img_ext_name.to_s
          image_tag "/uploads/sounds/image/thumbnail/#{thumb_path}", class: "thumbnail_img"
          #image_tag "/uploads/sounds/image/normal/#{normal_path}", class: "thumbnail_img"
        else
          # image_tagを用いてwanko.pngを表示してください
          image_tag "default.jpg",class: "thumbnail_img"
    end
  end
end

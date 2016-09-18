module SoundsHelper
    @@sound_init = "sid"
    @@image_init = "img"
    @@image_s = "_s"
    def image_for(sound)
        if sound.path
          # image_tagを用いてuserのプロフィール画像を表示してください
          #normal_path = sound.img_path.to_s + sound.img_ext_name.to_s
          thumb_path = @@image_init.to_s + sound.path.to_s + @@image_s.to_s + sound.img_ext_name.to_s
          image_tag "/uploads/sounds/image/thumbnail/#{thumb_path}", class: "thumbnail_img"
          #image_tag "/uploads/sounds/image/normal/#{normal_path}", class: "thumbnail_img"
          #↑class:でHTMLでのclassを設定できる。
        else
          # image_tagを用いてwanko.pngを表示してください
          image_tag "default.jpg",class: "thumbnail_img"
    end
  end
end

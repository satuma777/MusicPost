module SoundsHelper
    @@sound_init = "sid"
    @@image_init = "img"
    @@image_s = "_s"
    def image_for(sound, size)
        if sound.path
          # image_tagを用いてuserのプロフィール画像を表示してください
          #normal_path = sound.img_path.to_s + sound.img_ext_name.to_s
          thumb_path = "/uploads/sounds/" + sound.path.to_s + "/thumbnail/" +@@image_init.to_s + sound.path.to_s + @@image_s.to_s + sound.img_ext_name.to_s
          image_tag thumb_path, class: "thumbnail_img", :size => size.to_s + "x" + size.to_s
          #image_tag "/uploads/sounds/image/normal/#{normal_path}", class: "thumbnail_img"
          #↑class:でHTMLでのclassを設定できる。
          #↑thumb_pathはサムネイルのパス。
          #↑×の全角半角には気をつける。普通に入力すると全角。
        else
          # image_tagを用いてwanko.pngを表示してください
          image_tag "default.jpg",class: "thumbnail_img", size: size.to_s + "×" +size.to_s
      end
    end
    def audio_for(sound)
        if sound.path
          # image_tagを用いてuserのプロフィール画像を表示してください
          #normal_path = sound.img_path.to_s + sound.img_ext_name.to_s
          audio_path = "/uploads/sounds/" + sound.path.to_s + "/sound/" +@@sound_init.to_s + sound.path.to_s + sound.ext_name.to_s
          audio_tag(audio_path, :controls => true)
          #image_tag "/uploads/sounds/image/normal/#{normal_path}", class: "thumbnail_img"
          #↑class:でHTMLでのclassを設定できる。
          #↑thumb_pathはサムネイルのパス。
          #↑×の全角半角には気をつける。普通に入力すると全角。
        else
          # image_tagを用いてwanko.pngを表示してください
          audio_tag("default.mp3", :controls => true)
      end
    end
end

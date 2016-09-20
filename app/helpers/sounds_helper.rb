#↓"Settings."の付いたものは、/config/の"settings.yml"で定義している定数を表す。

module SoundsHelper
    def image_for(sound, size)
        if sound.path
          # image_tagを用いてuserのプロフィール画像を表示してください
          #normal_path = sound.img_path.to_s + sound.img_ext_name.to_s
          thumb_path = "/uploads/sounds/" + sound.path.to_s + "/thumbnail/" +Settings.nhead_image.to_s + sound.path.to_s + Settings.image_s.to_s + sound.img_ext_name.to_s
          image_tag thumb_path, class: "thumbnail_img", :size => size.to_s + "x" + size.to_s
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
          audio_path = "/uploads/sounds/" + sound.path.to_s + "/sound/" + Settings.nhead_sound.to_s + sound.path.to_s + sound.ext_name.to_s
          audio_tag(audio_path, :preload => 'metadata', :controls => true, class: "audio")
          #↑class:でHTMLでのclassを設定できる。
          #↑thumb_pathはサムネイルのパス。
          #↑×の全角半角には気をつける。普通に入力すると全角。
        else
          # image_tagを用いてwanko.pngを表示してください
          audio_tag("default.mp3", :controls => true)
      end
    end
end

class LikesController < ApplicationController

    def like
        sound = Sound.find(params[:sound_id])
        #↓変数likeに、current_userとbuildを用いてLikeインスタンスを代入している。
        like = current_user.likes.build(sound_id: sound.id)
        #↓saveメソッドで、likeを保存。
        like.save
        redirect_to sound
    end

    def unlike
        sound = Sound.find(params[:sound_id])
        #↓変数likeに、current_userとfind_byを用いてLikeインスタンスを代入している。
        like = current_user.likes.find_by(sound_id: sound.id)
        #↓destroyメソッドで、likeを削除。
        like.destroy
        redirect_to sound
    end

end

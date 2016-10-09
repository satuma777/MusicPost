class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:show, :edit, :update]
    before_action :set_user, only: [:show, :edit, :update, :destroy, :likes_sounds]
    before_action :correct_user, only: [:edit, :update]
    $count = 0

    def index
        @users = User.all
        $count += $count
        logger.debug($count)
    end

    def index_recommend
    end

    #↓ユーザーの投稿一覧を表示
    def show
        @sounds = @user.sounds
        @title = "投稿一覧"
    end

    def edit
    end

    def update
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to @user, notice: 'User was successfully updated.' }
                format.json { render :show, status: :ok, location: @user }
            else
                format.html { render :edit }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to users_url, notice: @user.name.to_s + 'は無事消去されました。' }
            format.json { head :no_content }
        end
    end

    def all_destroy
        @users = User.all
        @users.each do |user|
            user.destroy
        end
        respond_to do |format|
            format.html { redirect_to users_url, notice: '全てのユーザーが無事消去されました。' }
            format.json { head :no_content }
        end
    end

    #↓ユーザーがいいね！した音楽の一覧を表示。
    #↓モデルで定義したlike_soundsとはまた別のもの。
    #↓モデルで定義したlike_soundsはユーザーがいいね！をした音楽をすべて取ってくるメソッド。
    #↓下のコントローラーでは取ってきた音楽を利用してビューに反映させている。
    def like_sounds
        @sounds = @user.like_sounds
        @title = "いいね！一覧"
        #↓showで表示するもの（ユーザーが投稿した音楽）と
        #↓like_sounds（ユーザーがいいね！した音楽の一覧を表示）で表示するもの
        #↓はほとんど同じなので、一部だけ変更して同じビューを表示する。
        render :show
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :email)
    end

    def correct_user
        user = User.find(params[:id])
        if current_user.id != user.id
            redirect_to root_path, alert: '許可されていないページです'
        end
        #↑現在のユーザーとアクセスしようとしているページのユーザーIDが異なる場合はアクセスできないようにしている。
    end

end

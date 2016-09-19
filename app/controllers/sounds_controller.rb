#↓"Settings."の付いたものは、/config/の"settings.yml"で定義している定数を表す。

class SoundsController < ApplicationController
    require 'kconv'
    require 'mimemagic'
    require 'RMagick'
    require "fileutils"

    before_action :set_sound, only: [:show, :edit, :update, :destroy]

    def index
        @sounds = Sound.all
    end

    def index_recommend
    end

    def show
    end

    def show_melody
    end

    def new
        @sound_value = Settings.new_sound_value
        @thumb_value = Settings.new_thumb_value
        @sound = Sound.new
    end

    # GET /sounds/1/edit
    def edit
        @sound_value = Settings.edit_sound_value
        @thumb_value = Settings.edit_thumb_value
    end

    # POST /sounds
    # POST /sounds.json
    def create
        @sound = Sound.new(sound_params)
        use_for = "new"
        file = params[:sound][:upfile]
        file_img = params[:sound][:image]
        #↑params[:upfile]でもよい。params[:sound]とparamsは同じ見てよい。
        #↑その他の値、例えばidを取ってきたい時は、id = params[:sound][:id]（または、id = params[:id]）とする。
        perms = ['.mp3', '.ogg', '.wav']
        perms_img = ['.jpg', '.jpeg', '.gif', '.png']
        if !file.nil? && !file_img.nil?
            save_upfiles(file, file_img, perms, perms_img)
            #↑サムネイルとなる画像ファイルのチェック。
            unless @sound.valid?
                render :new
            else
                file_id = @sound.object_id
               @sound.set_sound(file, file_id, use_for)
               @sound.set_image(file_img, file_id, use_for)
               @sound.path = file_id
                if @sound.save then
                    redirect_to @sound, notice: "#{@sound.upfile.toutf8}をアップロードしました。"
                    #↑redirect_to sound_path(@sound.id)→redirect_to sound_path(@sound.id)→redirect_to @sound
                    #↑sound_path(@sound.id)でshowアクションに飛ぶ
                else
                    render :new
                end
            end
        else
            unless @sound.valid?
                    render :new
            end
        end
    end

    # PATCH/PUT /sounds/1
    # PATCH/PUT /sounds/1.json
    def update
        use_for = "edit"
        file = params[:upfile]
        file_img = params[:image]
        #↑params[:upfile]でもよい。params[:sound]とparamsは同じ見てよい。
        #↑その他の値、例えばidを取ってきたい時は、id = params[:sound][:id]（または、id = params[:id]）とする。
        perms = ['.mp3', '.ogg', '.wav']
        perms_img = ['.jpg', '.jpeg', '.gif', '.png']
        if !file.nil? || !file_img.nil?
            save_upfiles(file, file_img, perms, perms_img)
            #↑サムネイルとなる画像ファイルのチェック。
            unless @sound.valid?
                render :edit
            else
                file_id = @sound.path
               @sound.set_sound(file, file_id, use_for)
               @sound.set_image(file_img, file_id, use_for)
            end
        end
        respond_to do |format|
            if @sound.update(sound_params)
                format.html { redirect_to @sound, notice: '編集内容が更新されました。' }
                format.json { render :show, status: :ok, location: @sound }
            else
                format.html { render :edit }
                format.json { render json: @sound.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /sounds/1
    # DELETE /sounds/1.json
    def destroy
        upfolder_path = "./public/uploads/sounds/" + @sound.path.to_s
        #↑通常、一番前の"."（ドット）はいらないが、"FileUtils"を使う時は必要。
        FileUtils.rm_rf(upfolder_path, :secure => true) rescue nil
        @sound.destroy
        respond_to do |format|
            format.html { redirect_to sounds_url, notice: @sound.upfile.to_s + 'は無事消去されました。' }
            format.json { head :no_content }
        end
    end

    def all_destroy
        @sounds = Sound.all
        #↑Sound.allを使うと、テーブルの全てのデータを取得できる。
        upfolder_path = ""
        @sounds.each do |sound|
            upfolder_path = "./public/uploads/sounds/" + sound.path.to_s
            FileUtils.rm_rf(upfolder_path, :secure => true) rescue nil
        end
        @sounds.each do |sound|
            sound.destroy
        end
        respond_to do |format|
            format.html { redirect_to sounds_url, notice: '全てのファイルが無事消去されました。' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_sound
            @sound = Sound.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def sound_params
            params.require(:sound).permit(:title, :content, :upfile, :image)
        end

        def save_upfiles(file, file_img, perms, perms_img)
            file_org = file.original_filename
            file_org_img = file_img.original_filename
            #↓downcaseメソッドは、文字列中の大文字を小文字に変えた新しい文字列を返す。
            #↓.extname(filename)はファイル名 filename の拡張子部分(最後の "." に続く文字列)を 返す。
            #↓include?メソッドは、文字列の中に引数の文字列が含まれるかどうかを調べる。
            if !perms.include?(File.extname(file_org).downcase) then
               @sound.upfile = "ext_error"
            elsif MimeMagic.by_magic(file) != "audio/mp3" && MimeMagic.by_magic(file) != "audio/mpeg" && MimeMagic.by_magic(file) != "audio/wav" && MimeMagic.by_magic(file) != "audio/x-wav" && MimeMagic.by_magic(file) != "audio/ogg" && MimeMagic.by_magic(file) != "video/ogg" then
                @sound.upfile = "file_error"
            elsif file.size > Settings.size_sound.megabyte then
                @sound.upfile = "size_error"
            end
            #↑音声ファイルのチェック。
            if !perms_img.include?(File.extname(file_org_img).downcase) then
               @sound.image = "ext_error"
            elsif MimeMagic.by_magic(file_img) != "image/jpg" && MimeMagic.by_magic(file_img) != "image/jpeg" && MimeMagic.by_magic(file_img) != "image/png" && MimeMagic.by_magic(file_img) != "image/x-citrix-png" && MimeMagic.by_magic(file_img) != "image/x-citrix-jpeg" && MimeMagic.by_magic(file_img) != "image/x-png" && MimeMagic.by_magic(file_img) != "image/pjpeg" then
                @sound.image = "file_error"
            elsif file_img.size > Settings.size_image.megabyte then
                @sound.image = "size_error"
            end
            #↑サムネイルとなる画像ファイルのチェック。
        end
end

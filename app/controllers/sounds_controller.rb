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
        @sound_value = Settings.NEW_SOUND_VALUE
        @thumb_value = Settings.NEW_THUMB_VALUE
        @sound = Sound.new
    end

    # GET /sounds/1/edit
    def edit
        @sound_value = Settings.EDIT_SOUND_VALUE
        @thumb_value = Settings.NEW_THUMB_VALUE
    end

    # POST /sounds
    # POST /sounds.json
    def create
        @sound = Sound.new(sound_params)
        @sound_value = Settings.NEW_SOUND_VALUE
        @thumb_value = Settings.NEW_THUMB_VALUE
        #↑ファイル選択画面での注釈。大文字のスネークケース文字には、定数が代入されている。
        sound_change = true;
        img_change = true;
        file = params[:sound][:upfile]
        img_file = params[:sound][:image]
        #↑params[:upfile]でもよい。params[:sound]とparamsは同じ見てよい。
        #↑その他の値、例えばidを取ってきたい時は、id = params[:sound][:id]（または、id = params[:id]）とする。
        perms = ['.mp3', '.ogg', '.wav']
        img_perms = ['.jpg', '.jpeg', '.gif', '.png']
        if !file.nil? && !img_file.nil? then
            sound_org_name = file.original_filename
            sound_org_name = sound_org_name.kconv(Kconv::SJIS, Kconv::UTF8)
            img_org_name = img_file.original_filename
            img_org_name = img_org_name.kconv(Kconv::SJIS, Kconv::UTF8)

            check_upfiles(file, img_file, perms, img_perms, sound_org_name, img_org_name)
            #↑サムネイルとなる画像ファイルのチェック。
            unless @sound.valid? then
                render :new
            else
                file_id = @sound.object_id
               @sound.upload_sound(file, file_id, sound_org_name, sound_change)
               @sound.upload_image(img_file, file_id, img_org_name, img_change)
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
        @sound_value = Settings.EDIT_SOUND_VALUE
        @thumb_value = Settings.EDIT_THUMB_VALUE
        #↑ファイル選択画面での注釈。大文字のスネークケース文字には、定数が代入されている。
        sound_change = true;
        img_change = true;
        new_file = params[:sound][:upfile]
        img_new_file = params[:sound][:image]
        #↑params[:upfile]でもよい。params[:sound]とparamsは同じ見てよい。
        #↑その他の値、例えばidを取ってきたい時は、id = params[:sound][:id]（または、id = params[:id]）とする。
        perms = ['.mp3', '.ogg', '.wav']
        img_perms = ['.jpg', '.jpeg', '.gif', '.png']
        if !new_file.nil? || !img_new_file.nil?
            if !new_file.nil? then
                sound_org_name = new_file.original_filename
                sound_org_name = sound_org_name.kconv(Kconv::SJIS, Kconv::UTF8)
                upfolder_path = "./public/uploads/sounds/" + @sound.path.to_s + "/sound"
                FileUtils.rm_rf(upfolder_path, :secure => true) rescue nil
            else
                pre_sound_file = "./public/uploads/sounds/" + @sound.path.to_s + "/sound/" + Settings.SOUND_HEAD_NAME.to_s + @sound.path.to_s + @sound.ext_name.to_s
                file = File.open(pre_sound_file, 'rb')
                sound_org_name = Settings.SOUND_HEAD_NAME.to_s + @sound.path.to_s + @sound.ext_name.to_s
                sound_change = false
            end
            if !img_new_file.nil? then
                img_org_name = img_new_file.original_filename
                img_org_name = img_org_name.kconv(Kconv::SJIS, Kconv::UTF8)
                upfolder_path = "./public/uploads/sounds/" + @sound.path.to_s + "/thumbnail"
                FileUtils.rm_rf(upfolder_path, :secure => true) rescue nil
            else
                pre_img_file = "./public/uploads/sounds/" + @sound.path.to_s + "/thumbnail/" + Settings.IMAGE_HEAD_NAME.to_s + @sound.path.to_s  + @sound.img_ext_name.to_s
                img_file = File.open(pre_img_file, 'rb')
                img_org_name = Settings.IMAGE_HEAD_NAME.to_s + @sound.path.to_s + @sound.img_ext_name.to_s
                img_change = false
            end
            logger.debug "upfile=" 
            logger.debug(new_file)
            logger.debug(sound_org_name)
            logger.debug(@sound.upfile)
            logger.debug "img=" 
            logger.debug(img_new_file)
            logger.debug(img_org_name)
            logger.debug(@sound.image)
            #↑new_fileかimg_new_fileどちらかが空であれば、空のほうに編集前のファイルを入れる。
            check_upfiles(file, img_file, perms, img_perms, sound_org_name, img_org_name)
            #↑アップロードしたファイルのチェックを行う。
            unless @sound.valid?
            #↑アップロードしたファイルのバリデーションチェックを行う。
                render :edit
            else
               upfolder_path = "./public/uploads/sounds/" + @sound.path.to_s

               logger.debug "pre_path2="
               logger.debug(@sound.path.to_s)

                #↓そして、編集後に新しく作り直す。
                file_id = @sound.object_id

               logger.debug "cur_path2="
               logger.debug(file_id)

               @sound.upload_sound(file, file_id, sound_org_name, sound_change)
               @sound.upload_image(img_file, file_id, img_org_name, img_change)
               @sound.path = file_id

               logger.debug "sound_change="
               logger.debug(sound_change.to_s)
               logger.debug "img_change="
               logger.debug(img_change.to_s)

               if !sound_change
                   file.close
               end
               if !img_change
                   img_file.close
               end
               #↑通常、一番前の"."（ドット）はいらないが、"FileUtils"を使う時は必要。
               pre_folder_exist = File.exists?(upfolder_path.to_s)
               pre_file_exist = File.exists?(upfolder_path.to_s + "/thumbnail/" + Settings.IMAGE_HEAD_NAME.to_s + @sound.path.to_s  + @sound.img_ext_name.to_s)
               logger.debug "pre_folder_exist?="
               logger.debug(pre_folder_exist.to_s)
               logger.debug "pre_file_exist?="
               logger.debug(pre_folder_exist.to_s)
               logger.debug "cur_path="
               logger.debug(@sound.path.to_s)
               logger.debug "up_folder="
               logger.debug(upfolder_path.to_s)

               FileUtils.rm_rf(upfolder_path, :secure => true) rescue nil
               #↑編集前のデータをフォルダごと消去する。
               
               logger.debug "pre_folder_exist?="
               logger.debug(pre_folder_exist.to_s)
               logger.debug "pre_file_exist?="
               logger.debug(pre_folder_exist.to_s)
               logger.debug "cur_path="
               logger.debug(@sound.path.to_s)

               update_upfiles
            end
        else
            update_upfiles
        end
        #FileUtils.rm_rf(upfolder_path, :secure => true) rescue nil
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

        def check_upfiles(file, img_file, perms, img_perms, sound_org_name, img_org_name)
            logger.debug "image=" 
            logger.debug(img_org_name)
            if !file.nil? then
                #↓downcaseメソッドは、文字列中の大文字を小文字に変えた新しい文字列を返す。
                #↓.extname(filename)はファイル名 filename の拡張子部分(最後の "." に続く文字列)を 返す。
                #↓include?メソッドは、文字列の中に引数の文字列が含まれるかどうかを調べる。
                if !perms.include?(File.extname(sound_org_name).downcase) then
                   @sound.upfile = "ext_error"
                elsif MimeMagic.by_magic(file) != "audio/mp3" && MimeMagic.by_magic(file) != "audio/mpeg" && MimeMagic.by_magic(file) != "audio/wav" && MimeMagic.by_magic(file) != "audio/x-wav" && MimeMagic.by_magic(file) != "audio/ogg" && MimeMagic.by_magic(file) != "video/ogg" then
                    @sound.upfile = "file_error"
                elsif file.size > Settings.SOUND_DATA_SIZE.megabyte then
                    @sound.upfile = "size_error"
                end
                #↑音声ファイルのチェック。
            end
            if !img_file.nil? then
                if !img_perms.include?(File.extname(img_org_name).downcase) then
                   @sound.image = "ext_error"
                elsif MimeMagic.by_magic(img_file) != "image/jpg" && MimeMagic.by_magic(img_file) != "image/jpeg" && MimeMagic.by_magic(img_file) != "image/png" && MimeMagic.by_magic(img_file) != "image/x-citrix-png" && MimeMagic.by_magic(img_file) != "image/x-citrix-jpeg" && MimeMagic.by_magic(img_file) != "image/x-png" && MimeMagic.by_magic(img_file) != "image/pjpeg" then
                    @sound.image = "file_error"
                elsif img_file.size > Settings.SOUND_DATA_SIZE.megabyte then
                    @sound.image = "size_error"
                end
                #↑サムネイルとなる画像ファイルのチェック。
            end
        end

        def update_upfiles
            respond_to do |format|
                if @sound.update(sound_params) then
                    format.html { redirect_to @sound, notice: '編集内容が更新されました。' }
                    format.json { render :show, status: :ok, location: @sound }
                else
                    format.html { render :edit }
                    format.json { render json: @sound.errors, status: :unprocessable_entity }
                end
            end
        end

end

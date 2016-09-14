class SoundsController < ApplicationController
    before_action :set_sound, only: [:show, :edit, :update, :destroy]
    require 'kconv'
    require 'mimemagic'

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
        @sound = Sound.new
    end

    # GET /sounds/1/edit
    def edit
    end

    # POST /sounds
    # POST /sounds.json
    def create
        @sound = Sound.new(sound_params)
        file = params[:sound][:upfile]
        perms = ['.mp3', '.ogg', '.wav']
        if !file.nil?
            file_orgname = file.original_filename
            #↓downcaseメソッドは、文字列中の大文字を小文字に変えた新しい文字列を返す
            #↓.extname(filename)はファイル名 filename の拡張子部分(最後の "." に続く文字列)を 返します。
            #↓include?メソッドは、文字列の中に引数の文字列が含まれるかどうかを調べる
            if !perms.include?(File.extname(file_orgname).downcase) then
               @sound.upfile = "ext_error"
            elsif MimeMagic.by_magic(file) != "audio/mp3" && MimeMagic.by_magic(file) != "audio/mpeg" && MimeMagic.by_magic(file) != "audio/wav" && MimeMagic.by_magic(file) != "audio/x-wav" && MimeMagic.by_magic(file) != "audio/ogg" && MimeMagic.by_magic(file) != "video/ogg" && MimeMagic.by_magic(file) != "audio/mpeg" then
                @sound.upfile = "file_error"
            elsif file.size > 15.megabyte then
                @sound.upfile = "size_error"
            end
            unless @sound.valid?
                render :new
            else
               @sound.set_sound(file)
                if @sound.save then
                redirect_to @sound, notice: "#{file_orgname.toutf8}をアップロードしました。"
                #↑redirect_to sound_path(@sound.id)→redirect_to sound_path(@sound.id)→redirect_to @sound
                #↑sound_path(@sound.id)でshowアクションに飛ぶ
                else
                    render :new
                end
            end
        else
            render :new
        end
    end

    # PATCH/PUT /sounds/1
    # PATCH/PUT /sounds/1.json
    def update
        respond_to do |format|
            if @sound.update(sound_params)
                format.html { redirect_to @sound, notice: 'Sound was successfully updated.' }
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
        @sound.destroy
        respond_to do |format|
            format.html { redirect_to sounds_url, notice: 'Sound was successfully destroyed.' }
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
            params.require(:sound).permit(:title, :content, :upfile, :image, :path ,:ext_name)
        end
end

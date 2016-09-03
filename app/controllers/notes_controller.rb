class NotesController < ApplicationController
    before_action :set_note, only: [:show, :edit, :update, :destroy]

    def index
        @notes = Note.all
    end

    def index_recommend
    end

    def show
    end

    def show_melody
    end

    def new
        @note = Note.new
    end

    def create
        @note = Note.new(note_params)
        @note.save
        if @note.save
            render show
        else

        end
    end

    def update
        respond_to do |format|
            if @note.update(note_params)
                format.html { redirect_to @note, notice: 'Note was successfully updated.' }
                format.json { render :show, status: :ok, location: @note }
            else
                format.html { render :edit }
                format.json { render json: @note.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @note.destroy
        respond_to do |format|
            format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    def set_note
        @note = Note.find(params[:id])
    end

    def note_params
        params.require(:note).permit(:title, :content)
    end
end

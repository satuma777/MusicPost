class HomeController < ApplicationController
    def top
        @sound_value = Settings.NEW_SOUND_VALUE
        @thumb_value = Settings.NEW_THUMB_VALUE
        @sound = Sound.new
        @sounds = Sound.all.order(created_at: :desc)
    end

    def about
    end

end

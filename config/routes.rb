#↓urlが同じになるものはVerbで区別され、それでも区別できないものは、上から順に実行される。
Rails.application.routes.draw do

    devise_for :users, :controllers => {
        :registrations => 'users/registrations'
    }

    resources :users, only:[:index, :show, :edit, :update, :destroy] do
        member do
            get :like_sounds
        end
        collection do
            get :index_recommend, as: 'recommend'
        end
    end
    delete 'all/users' => 'users#all_destroy', as: 'destroy_all_users'

    resources :sounds do
        collection do
            get :show_melody
            get :index_recommend, as: 'recommend'
        end
    end
    delete 'all/sounds' => 'sounds#all_destroy', as: 'destroy_all_sounds'
    #↑collectionの中に入れてはいけない。入れると、パスの衝突があるのか、all_deleteがうまく作動しなくなる。
    #↑ディレクトリ操作などでうまくいかないときは、パスを確認する。

    resources :notes

    post '/like/:sound_id' => 'likes#like',as: 'like'
    delete '/unlike/:sound_id' => 'likes#unlike', as: 'unlike'

    get 'home_lesson/top'
    get 'home_matching/top'
    root 'home#top'
    get '/alert' => 'home#alert'

end

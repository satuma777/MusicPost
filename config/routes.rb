#↓urlが同じになるものはVerbで区別され、それでも区別できないものは、上から順に実行される。
Rails.application.routes.draw do
    devise_for :users
    resources :users do
        collection do
            get :index_recommend, as: 'recommend'
        end
    end
    resources :sounds do
        collection do
            get :show_melody
            get :index_recommend, as: 'recommend'
        end
    end
    resources :notes

    get 'home_lesson/top'
    get 'home_matching/top'
    root 'home#top'
    get '/alert' => 'home#alert'

    delete 'all/sounds' => 'sounds#all_destroy', as: 'destroy_all_sounds'
    #↑collectionの中に入れてはいけない。入れると、パスの衝突があるのか、all_deleteがうまく作動しなくなる。
    #↑ディレクトリ操作などでうまくいかないときは、パスを確認する。
    delete 'all/users' => 'users#all_destroy', as: 'destroy_all_users'


end

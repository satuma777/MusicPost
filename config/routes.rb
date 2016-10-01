Rails.application.routes.draw do
  devise_for :users
    resources :sounds do
        collection do
            get :show_melody
            get :index_recommend, as: 'recommend'
        end
    end
    resources :users do
        collection do
            get :index_recommend, as: 'recommend'
        end
    end
    resources :notes

    get 'home_lesson/top'
    get 'home_matching/top'
    root 'home#top'
    get '/alert' => 'home#alert'

    delete '/sounds' => 'sounds#all_destroy', as: 'all_destroy'
    #↑collectionの中に入れてはいけない。入れると、パスの衝突があるのか、all_deleteがうまく作動しなくなる。
    #↑ディレクトリ操作などでうまくいかないときは、パスを確認する。

end

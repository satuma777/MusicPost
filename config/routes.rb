Rails.application.routes.draw do
  get 'sound_upload/upload'

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

end

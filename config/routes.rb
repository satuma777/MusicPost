Rails.application.routes.draw do
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

end

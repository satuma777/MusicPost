Rails.application.routes.draw do
    get 'home_lesson/top'

    get 'home_matching/top'

    root 'home#top'
    get '/alert' => 'home#alert'

    resources :users
    resources :notes

    get '/show/melody' => 'notes#show_melody'
    get '/notes/index/recommend' => 'notes#index_recommend' , as: 'notes_recommend'
    get '/users/index/recommend' => 'users#index_recommend' , as: 'users_recommend'

end

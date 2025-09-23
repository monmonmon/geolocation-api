Rails.application.routes.draw do
  namespace :geolocations do
    resources :ip, only: %i[show destroy], param: :ip, constraints: { ip: /[^\/]+/ }
    resources :ip, only: %i[create]
    resources :url, only: %i[show destroy], param: :url, constraints: { url: /[A-z0-9:\/\.\?#&=%_-]+/ }
    resources :url, only: %i[create]
  end
end

Rails.application.routes.draw do
  # redirects
  get '/users' => redirect('/users/sign_up')
  get '/' => redirect('/users/sign_in')

  # users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # rooms
  resources :users do
    resources :rooms, only: %i() do
      collection do
        get :show_all_rooms
      end
    end
  end
  get 'rooms/:id', to: 'rooms#show_room', as: :show_room
  # rooms(api)
  namespace :api do
    namespace :v1, format: 'json' do
      get 'rooms/:id/get_user_id', to: 'rooms#get_user_id'
    end
  end

  # messages
  namespace :api do
    namespace :v1, format: 'json' do
       resources :rooms do
        member do
          get :get_all_messages
        end
        resources :users do
          resources :messages, only: %i(create destroy) do
          end
        end
       end
      end
  end

  # likes
  namespace :api do
    namespace :v1, format: 'json' do
       resources :users do
        resources :messages do
          resources :likes, only: %i(create) do
            collection do
              delete :remove_like
            end
          end
        end
      end
      end
  end

  namespace :api do
    namespace :v1, format: 'json' do
  get 'users/:id/liked_messages', to: 'likes#get_all_liked_messages'
    end
  end
end

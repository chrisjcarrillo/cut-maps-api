Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :uploads, only: [:index, :show] do
        collection do
          get 'login'
          get 'get_folder'
          get 'upload_file'
          get 'create_folder'
          get 'get_token'
          root 'uploads#index'
          # get 'reports'
          # get 'detailed_leads'
          # get 'generate_accelerated_responsivness'
          # root 'lsa_reports#accounts'
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

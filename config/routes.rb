Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resource :session, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :edit, :update, :show]
    resources :questions, only: [:index, :new, :edit, :create, :update, :destroy, :show]
    resources :questions do 
      resources :answers, only: [:create, :destroy, :update, :edit] 
    end
    root 'pages#index'
    # все маршруты, в config/locales лежат вайлы с переводом
    # шемы, которые установил: фейкер, каминари, бикрипт, интернационализации
  end
end

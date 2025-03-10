Rails.application.routes.draw do
  # ユーザー認証（devise）
  devise_for :users

  # ダッシュボード
  get 'dashboard', to: 'users#dashboard', as: :dashboard
  root "users#dashboard"

  # ユーザー管理（一覧・詳細・編集）
  resources :users, only: %i[index show edit update]

  # チーム管理（作成・編集・メンバー管理）
  resources :teams do
    resources :items, only: %i[new create show edit update destroy] do
      member do
        patch :toggle_status
      end
      collection do
        get :history
      end
    end
  
    member do
      post :join
      post :leave
      get :members
      post :add_member
      delete :remove_member
      post :transfer_ownership
    end
  end
end

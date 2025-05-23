Rails.application.routes.draw do
  namespace :v1 do
    put '/auth/sign_in', to: 'auth#sign_in'
    post '/auth/sign_up', to: 'auth#sign_up'
    post '/auth/recover_password', to: 'auth#recover_password'
    get '/auth/confirm_email', to: 'auth#confirm_email'
    post '/auth/resend_credential_email', to: 'auth#resend_credential_email'
    get '/auth/confirm_recover_password', to: 'auth#confirm_recover_password'
    post '/auth/confirm_recover_password', to: 'auth#confirm_recover_password'

    namespace :users do
      get '/infos', to: 'users#show'

      post '/bank_account_transfers', to: 'bank_account_transfers#create'
      get '/bank_account_transfers/statements', to: 'bank_account_transfers#index'
      

      get '/bank_accounts', to: 'user_bank_accounts#index'
      get '/bank_accounts/my', to: 'user_bank_accounts#my'
    end
  end
end

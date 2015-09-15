Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "customers/find", to: "customers#find"
      get "merchants/find"
      get "invoices/find"
      get "items/find"
      get "invoice_items/find"
      get "transactions/find"
      resources :customers,     except: [:new, :edit]
      resources :merchants,     except: [:new, :edit]
      resources :invoices,      except: [:new, :edit]
      resources :items,         except: [:new, :edit]
      resources :invoice_items, except: [:new, :edit]
      resources :transactions,  except: [:new, :edit]
    end
  end
end

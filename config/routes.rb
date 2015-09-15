Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers,     except: [:new, :edit]
      resources :merchants,     except: [:new, :edit]
      resources :invoices,      except: [:new, :edit]
      resources :items,         except: [:new, :edit]
      resources :invoice_items, except: [:new, :edit]
      resources :transactions,  except: [:new, :edit]

      get "customers/find", to: "customers#find"
      get "merchants/find", to: "merchants#find"
      get "invoices/find", to: "invoices#find"
      get "items/find", to: "items#find"
      get "invoice_items/find", to: "invoice_items#find"
      get "transactions/find", to: "transactions#find"

      get "customers/find_all", to: "customers#find_all"
      get "merchants/find_all", to: "merchants#find_all"
      get "invoices/find_all", to: "invoices#find_all"
      get "items/find_all", to: "items#find_all"
      get "invoice_items/find_all", to: "invoice_items#find_all"
      get "transactions/find_all", to: "transactions#find_all"
    end
  end
end

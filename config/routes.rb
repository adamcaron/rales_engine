Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      get "items/:id/merchant",         to: "items#merchant"
      get "items/:id/invoice_items",    to: "items#invoice_items"

      get "invoice_items/:id/item",     to: "invoice_items#item"
      get "invoice_items/:id/invoice",  to: "invoice_items#invoice"

      get "invoices/:id/merchant",      to: "invoices#merchant"
      get "invoices/:id/customer",      to: "invoices#customer"
      get "invoices/:id/items",         to: "invoices#items"
      get "invoices/:id/invoice_items", to: "invoices#invoice_items"
      get "invoices/:id/transactions",  to: "invoices#transactions"

      get "merchants/:id/invoices",     to: "merchants#invoices"
      get "merchants/:id/items",        to: "merchants#items"

      get "customers/find",             to: "customers#find"
      get "merchants/find",             to: "merchants#find"
      get "invoices/find",              to: "invoices#find"
      get "items/find",                 to: "items#find"
      get "invoice_items/find",         to: "invoice_items#find"
      get "transactions/find",          to: "transactions#find"

      get "customers/find_all",         to: "customers#find_all"
      get "merchants/find_all",         to: "merchants#find_all"
      get "invoices/find_all",          to: "invoices#find_all"
      get "items/find_all",             to: "items#find_all"
      get "invoice_items/find_all",     to: "invoice_items#find_all"
      get "transactions/find_all",      to: "transactions#find_all"

      get "customers/random",           to: "customers#random"
      get "merchants/random",           to: "merchants#random"
      get "invoices/random",            to: "invoices#random"
      get "items/random",               to: "items#random"
      get "invoice_items/random",       to: "invoice_items#random"
      get "transactions/random",        to: "transactions#random"

      resources :customers,     except: [:new, :edit]
      resources :merchants,     except: [:new, :edit]
      resources :invoices,      except: [:new, :edit]
      resources :items,         except: [:new, :edit]
      resources :invoice_items, except: [:new, :edit]
      resources :transactions,  except: [:new, :edit]
    end
  end
end

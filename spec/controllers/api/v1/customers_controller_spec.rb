require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  scenario "#show" do
    Customer.create(first_name: "John", last_name: "Doe")

    get :show, format: :json, id: Customer.first.id

    customer = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(customer[:first_name]).to eq("John")
    expect(customer[:last_name]).to eq("Doe")
  end
end

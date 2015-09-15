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

  scenario "#find" do
    customer = Customer.create(first_name: "John", last_name: "Doe")

    get :find, format: :json, first_name: Customer.last.first_name
    json_customer = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_customer[:id]).to eq(customer.id)

    get :find, format: :json, last_name: Customer.last.last_name
    json_customer = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_customer[:id]).to eq(customer.id)
  end

  scenario "#find_all" do
    customer1 = Customer.create(first_name: "John", last_name: "Doe")
    customer2 = Customer.create(first_name: "Jane", last_name: "Johnson")
    customer3 = Customer.create(first_name: "Ruth", last_name: "Personson")
    customer4 = Customer.create(first_name: "Tony", last_name: "Personson")

    get :find_all, format: :json, last_name: "Personson"
    json_customers = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_customers.count).to eq(2)
    expect(json_customers.first[:id]).to eq(customer3.id)
    expect(json_customers.last[:id]).to eq(customer4.id)
    expect(json_customers.first[:last_name]).to eq("Personson")
    expect(json_customers.last[:last_name]).to eq("Personson")
  end
end

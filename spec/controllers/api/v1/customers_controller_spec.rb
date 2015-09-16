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

  scenario "#random" do
    900.times { Customer.create(first_name: "John", last_name: "Doe") }

    get :random, format: :json
    json_customer1 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)

    get :random, format: :json
    json_customer2 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_customer2[:id]).to_not eq(json_customer1[:id])

    get :random, format: :json
    json_customer3 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_customer3[:id]).to_not eq(json_customer1[:id])
    expect(json_customer3[:id]).to_not eq(json_customer2[:id])
  end

  scenario "#invoices" do
    customer = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant = Merchant.create(name: "Alfonse Capone")
    invoice1 = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice2 = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice3 = Invoice.create(status: "pending", customer_id: customer.id, merchant_id: merchant.id)

    get :invoices, format: :json, id: customer.id

    json_invoices = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_invoices.count).to eq(3)
    json_invoices.each do |invoice|
      expect(invoice[:customer_id]).to eq(customer.id)
    end
  end

  scenario "#transactions" do
    customer     = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant     = Merchant.create(name: "Alfonse Capone")
    invoice      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    transaction1 = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id)
    transaction2 = Transaction.create(credit_card_number: "4844518708741275", result: "success", invoice_id: invoice.id)
    transaction3 = Transaction.create(credit_card_number: "4214497729954420", result: "failed", invoice_id: invoice.id)

    get :transactions, format: :json, id: customer.id

    json_transactions = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_transactions.count).to eq(3)
    expect(json_transactions[0][:credit_card_number]).to eq("4654405418249632")
    expect(json_transactions[0][:result]).to eq("success")
    expect(json_transactions[0][:invoice_id]).to eq(invoice.id)
    expect(json_transactions[1][:credit_card_number]).to eq("4844518708741275")
    expect(json_transactions[1][:result]).to eq("success")
    expect(json_transactions[1][:invoice_id]).to eq(invoice.id)
    expect(json_transactions[2][:credit_card_number]).to eq("4214497729954420")
    expect(json_transactions[2][:result]).to eq("failed")
    expect(json_transactions[2][:invoice_id]).to eq(invoice.id)
  end
end

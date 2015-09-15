require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  scenario "#show" do
    customer = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant = Merchant.create(name: "Alfonse Capone")
    Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)

    get :show, format: :json, id: Invoice.first.id

    invoice = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(invoice[:status]).to eq("shipped")
    expect(invoice[:customer_id]).to eq(customer.id)
    expect(invoice[:merchant_id]).to eq(merchant.id)
  end

  scenario "#find" do
    customer = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant = Merchant.create(name: "Alfonse Capone")
    invoice =  Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)

    get :find, format: :json, status: invoice.status
    json_invoice = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_invoice[:id]).to eq(invoice.id)

    get :find, format: :json, customer_id: invoice.customer_id
    json_invoice = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_invoice[:id]).to eq(invoice.id)

    get :find, format: :json, merchant_id: invoice.merchant_id
    json_invoice = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_invoice[:id]).to eq(invoice.id)
  end

  scenario "#find_all" do
    customer = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant = Merchant.create(name: "Alfonse Capone")
    invoice1 = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice2 = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice3 = Invoice.create(status: "pending", customer_id: customer.id, merchant_id: merchant.id)

    get :find_all, format: :json, status: "shipped"
    json_invoice = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_invoice.count).to eq(2)
    expect(json_invoice.first[:status]).to eq("shipped")
    expect(json_invoice.last[:status]).to eq("shipped")
  end
end
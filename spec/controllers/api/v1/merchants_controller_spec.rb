require 'rails_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  scenario "#show" do
    Merchant.create(name: "Lemony Snicket")

    get :show, format: :json, id: Merchant.first.id

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(merchant[:name]).to eq("Lemony Snicket")
  end

  scenario "#find" do
    Merchant.create(name: "Lemony Snicket")

    get :find, format: :json, first_name: Merchant.last.name
    json_merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchant[:name]).to eq("Lemony Snicket")
  end

  scenario "#find_all" do
    merchant1 = Merchant.create(name: "Lemony Snicket")
    merchant2 = Merchant.create(name: "Lemony Snicket")
    merchant3 = Merchant.create(name: "Jiminy Cricket")

    get :find_all, format: :json, name: "Lemony Snicket"
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(2)
    expect(json_merchants.first[:name]).to eq("Lemony Snicket")
    expect(json_merchants.last[:name]).to eq("Lemony Snicket")
  end

  scenario "#random" do
    900.times { Merchant.create(name: "Lemony Snicket") }

    get :random, format: :json
    json_merchant1 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)

    get :random, format: :json
    json_merchant2 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchant2[:id]).to_not eq(json_merchant1[:id])

    get :random, format: :json
    json_merchant3 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchant3[:id]).to_not eq(json_merchant1[:id])
    expect(json_merchant3[:id]).to_not eq(json_merchant2[:id])
  end

  scenario "#items" do
    merchant = Merchant.create(name: "Lemony Snicket")
    item1    = Item.create(name: "Thing", description: "Awesome", unit_price: "4500.00", merchant_id: merchant.id)
    item2    = Item.create(name: "Thing", description: "Awesome", unit_price: "4500.00", merchant_id: merchant.id)
    item3    = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)

    get :items, format: :json, id: merchant.id

    json_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(3)
    json_items.each do |item|
      expect(item[:merchant_id]).to eq(merchant.id)
    end
  end

  scenario "#invoices" do
    customer      = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant      = Merchant.create(name: "Alfonse Capone")
    invoice1      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice2      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice3      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)

    get :invoices, format: :json, id: merchant.id

    json_invoices = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_invoices.count).to eq(3)
    json_invoices.each do |invoice|
      expect(invoice[:merchant_id]).to eq(merchant.id)
    end
  end
end
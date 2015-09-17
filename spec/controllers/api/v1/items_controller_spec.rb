require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  scenario "#index" do
    merchant = Merchant.create(name: "Alphonse Capone")
    9.times { Item.create(name: "Thing", description: "Awesome", unit_price: "4500.95", merchant_id: merchant.id) }

    get :index, format: :json

    json_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(9)
  end

  scenario "#show" do
    merchant = Merchant.create(name: "Alphonse Capone")
    Item.create(name: "Thing", description: "Awesome", unit_price: "99.99", merchant_id: merchant.id)

    get :show, format: :json, id: Item.first.id

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(item[:name]).to eq("Thing")
    expect(item[:description]).to eq("Awesome")
    expect(item[:unit_price]).to eq("99.99")
    expect(item[:merchant_id]).to eq(merchant.id)
  end

  scenario "#find" do
    merchant = Merchant.create(name: "Alphonse Capone")
    item = Item.create(name: "Thing", description: "Awesome", unit_price: "99.99", merchant_id: merchant.id)

    get :find, format: :json, name: item.name
    json_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_item[:id]).to eq(item.id)

    get :find, format: :json, description: item.description
    json_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_item[:id]).to eq(item.id)

    get :find, format: :json, unit_price: item.unit_price
    json_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_item[:id]).to eq(item.id)

    get :find, format: :json, merchant_id: item.merchant_id
    json_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_item[:id]).to eq(item.id)
  end

  scenario "#find_all" do
    merchant = Merchant.create(name: "Alphonse Capone")
    item1 = Item.create(name: "Thing", description: "Awesome", unit_price: "4500.95", merchant_id: merchant.id)
    item2 = Item.create(name: "Thing", description: "Awesome", unit_price: "4500.95", merchant_id: merchant.id)
    item3 = Item.create(name: "Thing", description: "Awesome", unit_price: "2700.00", merchant_id: merchant.id)

    get :find_all, format: :json, unit_price: "4500.95"
    json_items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(2)
    expect(json_items.first[:unit_price]).to eq("4500.95")
    expect(json_items.last[:unit_price]).to eq("4500.95")
  end

  scenario "#random" do
    merchant = Merchant.create(name: "Alphonse Capone")
    900.times { Item.create(name: "Thing", description: "Awesome", unit_price: "4500.00", merchant_id: merchant.id) }

    get :random, format: :json
    json_item1 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)

    get :random, format: :json
    json_item2 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_item2[:id]).to_not eq(json_item1[:id])

    get :random, format: :json
    json_item3 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_item3[:id]).to_not eq(json_item1[:id])
    expect(json_item3[:id]).to_not eq(json_item2[:id])
  end

  scenario "#invoice_items" do
    customer      = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant      = Merchant.create(name: "Alphonse Capone")
    invoice1      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice2      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice3      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    item          = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)
    invoice_item1 = InvoiceItem.create(quantity: 17, unit_price: "100000.00", item_id: item.id, invoice_id: invoice1.id)
    invoice_item2 = InvoiceItem.create(quantity: 17, unit_price: "100000.00", item_id: item.id, invoice_id: invoice2.id)
    invoice_item3 = InvoiceItem.create(quantity: 17, unit_price: "100000.00", item_id: item.id, invoice_id: invoice3.id)

    get :invoice_items, format: :json, id: item.id

    json_invoice_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_invoice_items.count).to eq(3)
    json_invoice_items.each do |invoice_item|
      expect(invoice_item[:item_id]).to eq(item.id)
    end
  end

  scenario "#merchant" do
    customer = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant = Merchant.create(name: "Alphonse Capone")
    invoice  = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    item     = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)

    get :merchant, format: :json, id: item.id

    json_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_merchant[:id]).to eq(merchant.id)
  end

  scenario "#most_revenue" do
    customer      = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant1     = Merchant.create(name: "Penny Merchantheimer")
    merchant2     = Merchant.create(name: "Merch Merchanstein")
    merchant3     = Merchant.create(name: "Merchy McMerchantson")
    invoice1      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant1.id)
    invoice2      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant2.id)
    invoice3      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant3.id)
    item1         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.00", merchant_id: merchant1.id)
    item2         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.00", merchant_id: merchant2.id)
    item3         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.00", merchant_id: merchant3.id)
    invoice_item1 = InvoiceItem.create(quantity: 1, unit_price: "100.00", item_id: item1.id, invoice_id: invoice1.id)
    invoice_item2 = InvoiceItem.create(quantity: 5, unit_price: "100.00", item_id: item2.id, invoice_id: invoice2.id)
    invoice_item3 = InvoiceItem.create(quantity: 9, unit_price: "100.00", item_id: item3.id, invoice_id: invoice3.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice1.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice2.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice3.id)

    get :most_revenue, format: :json, quantity: 2
    json_items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(2)
    expect(json_items.first[:id]).to eq(item3.id)
    expect(json_items.last[:id]).to eq(item2.id)

    get :most_revenue, format: :json, quantity: 1
    json_items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(1)
    expect(json_items.first[:id]).to eq(item3.id)

    get :most_revenue, format: :json, quantity: 3
    json_items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(3)
    expect(json_items[0][:id]).to eq(item3.id)
    expect(json_items[1][:id]).to eq(item2.id)
    expect(json_items[2][:id]).to eq(item1.id)
  end
end
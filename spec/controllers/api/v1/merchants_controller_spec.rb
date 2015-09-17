require 'rails_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  scenario "#index" do
    9.times { Merchant.create(name: "John") }

    get :index, format: :json

    json_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(9)
  end

  scenario "#show" do
    Merchant.create(name: "Lemony Snicket")

    get :show, format: :json, id: Merchant.first.id

    json_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_merchant[:name]).to eq("Lemony Snicket")
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
    merchant      = Merchant.create(name: "Alphonse Capone")
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
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(2)
    expect(json_merchants.first[:id]).to eq(merchant3.id)
    expect(json_merchants.last[:id]).to eq(merchant2.id)

    get :most_revenue, format: :json, quantity: 1
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(1)
    expect(json_merchants.first[:id]).to eq(merchant3.id)

    get :most_revenue, format: :json, quantity: 3
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(3)
    expect(json_merchants[0][:id]).to eq(merchant3.id)
    expect(json_merchants[1][:id]).to eq(merchant2.id)
    expect(json_merchants[2][:id]).to eq(merchant1.id)
  end

  scenario "#most_items" do
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

    get :most_items, format: :json, quantity: 2
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(2)
    expect(json_merchants.first[:id]).to eq(merchant3.id)
    expect(json_merchants.last[:id]).to eq(merchant2.id)

    get :most_revenue, format: :json, quantity: 1
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(1)
    expect(json_merchants.first[:id]).to eq(merchant3.id)

    get :most_revenue, format: :json, quantity: 3
    json_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_merchants.count).to eq(3)
    expect(json_merchants[0][:id]).to eq(merchant3.id)
    expect(json_merchants[1][:id]).to eq(merchant2.id)
    expect(json_merchants[2][:id]).to eq(merchant1.id)
  end

  scenario "#revenue (total by date)" do
    customer      = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant1     = Merchant.create(name: "Penny Merchantheimer")
    merchant2     = Merchant.create(name: "Merch Merchanstein")
    merchant3     = Merchant.create(name: "Merchy McMerchantson")
    invoice1      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant1.id, created_at: "2012-03-23 02:58:15 UTC")
    invoice2      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant2.id, created_at: "2012-03-23 02:58:15 UTC")
    invoice3      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant3.id, created_at: "2012-03-23 02:58:15 UTC")
    item1         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.22", merchant_id: merchant1.id)
    item2         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.22", merchant_id: merchant2.id)
    item3         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.22", merchant_id: merchant3.id)
    invoice_item1 = InvoiceItem.create(quantity: 1, unit_price: "100.22", item_id: item1.id, invoice_id: invoice1.id)
    invoice_item2 = InvoiceItem.create(quantity: 1, unit_price: "100.22", item_id: item2.id, invoice_id: invoice2.id)
    invoice_item3 = InvoiceItem.create(quantity: 1, unit_price: "100.22", item_id: item3.id, invoice_id: invoice3.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice1.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice2.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice3.id)

    get :revenue, format: :json, date: invoice1.created_at
    json_revenue = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_revenue).to eq({:revenue=>"300.66"})
  end

  scenario "#revenue (for one merchant)" do
    customer      = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant      = Merchant.create(name: "Merchy McMerchantson")
    invoice1      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice2      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    invoice3      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    item1         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.22", merchant_id: merchant.id)
    item2         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.22", merchant_id: merchant.id)
    item3         = Item.create(name: "Thing", description: "Awesome", unit_price: "100.22", merchant_id: merchant.id)
    invoice_item1 = InvoiceItem.create(quantity: 1, unit_price: "100.22", item_id: item1.id, invoice_id: invoice1.id)
    invoice_item2 = InvoiceItem.create(quantity: 1, unit_price: "100.22", item_id: item2.id, invoice_id: invoice2.id)
    invoice_item3 = InvoiceItem.create(quantity: 1, unit_price: "100.22", item_id: item3.id, invoice_id: invoice3.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice1.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice2.id)
    transaction   = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice3.id)

    get :revenue, format: :json, id: merchant.id
    json_revenue = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_revenue).to eq({:revenue=>"300.66"})
  end
end
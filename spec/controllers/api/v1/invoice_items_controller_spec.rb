require 'rails_helper'

RSpec.describe Api::V1::InvoiceItemsController, type: :controller do
  scenario "#show" do
    customer = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant = Merchant.create(name: "Alfonse Capone")
    invoice  = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    item     = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00")
    InvoiceItem.create(quantity: 2, unit_price: "100000.00", item_id: item.id, invoice_id: invoice.id)

    get :show, format: :json, id: InvoiceItem.last.id

    invoice_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(invoice_item[:quantity]).to eq(2)
    expect(invoice_item[:unit_price]).to eq("100000.00")
    expect(invoice_item[:item_id]).to eq(item.id)
    expect(invoice_item[:invoice_id]).to eq(invoice.id)
  end

  scenario "#find" do
    customer     = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant     = Merchant.create(name: "Alfonse Capone")
    invoice      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    item         = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)
    invoice_item = InvoiceItem.create(quantity: 2, unit_price: "100000.00", item_id: item.id, invoice_id: invoice.id)

    get :find, format: :json, quantity: invoice_item.quantity
    json_invoice_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_invoice_item[:id]).to eq(invoice_item.id)

    get :find, format: :json, unit_price: invoice_item.unit_price
    json_invoice_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_invoice_item[:id]).to eq(invoice_item.id)

    get :find, format: :json, item_id: invoice_item.item_id
    json_invoice_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_invoice_item[:id]).to eq(invoice_item.id)

    get :find, format: :json, invoice_id: invoice_item.invoice_id
    json_invoice_item = JSON.parse(response.body, symbolize_names: true)
    expect(json_invoice_item[:id]).to eq(invoice_item.id)
  end
end

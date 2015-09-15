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
end

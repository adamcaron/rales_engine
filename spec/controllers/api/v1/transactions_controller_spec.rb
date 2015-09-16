require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  scenario "#show" do
    customer    = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant    = Merchant.create(name: "Alfonse Capone")
    invoice     = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    transaction = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id)

    get :show, format: :json, id: Transaction.last.id

    json_transaction = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_transaction[:credit_card_number]).to eq(transaction.credit_card_number)
    expect(json_transaction[:result]).to eq(transaction.result)
    expect(json_transaction[:invoice_id]).to eq(transaction.invoice_id)
  end

  scenario "#find" do
    customer    = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant    = Merchant.create(name: "Alfonse Capone")
    invoice     = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    transaction = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id)

    get :find, format: :json, credit_card_number: transaction.credit_card_number
    json_transaction = JSON.parse(response.body, symbolize_names: true)
    expect(json_transaction[:id]).to eq(transaction.id)

    get :find, format: :json, result: transaction.result
    json_transaction = JSON.parse(response.body, symbolize_names: true)
    expect(json_transaction[:id]).to eq(transaction.id)

    get :find, format: :json, invoice_id: transaction.invoice_id
    json_transaction = JSON.parse(response.body, symbolize_names: true)
    expect(json_transaction[:id]).to eq(transaction.id)
  end

  scenario "#find_all" do
    customer     = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant     = Merchant.create(name: "Alfonse Capone")
    invoice      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    transaction1 = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id)
    transaction2 = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id)
    transaction3 = Transaction.create(credit_card_number: "4654405418249632", result: "failed", invoice_id: invoice.id)

    get :find_all, format: :json, result: "success"
    json_transactions = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_transactions.count).to eq(2)
    expect(json_transactions.first[:result]).to eq("success")
    expect(json_transactions.last[:result]).to eq("success")
  end

  scenario "#random" do
    customer     = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant     = Merchant.create(name: "Alfonse Capone")
    invoice      = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    900.times { Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id) }

    get :random, format: :json
    json_transaction1 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)

    get :random, format: :json
    json_transaction2 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_transaction2[:id]).to_not eq(json_transaction1[:id])

    get :random, format: :json
    json_transaction3 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_transaction3[:id]).to_not eq(json_transaction1[:id])
    expect(json_transaction3[:id]).to_not eq(json_transaction2[:id])
  end

  scenario "#invoice" do
    customer    = Customer.create(first_name: "Joe", last_name: "Shmo")
    merchant    = Merchant.create(name: "Alfonse Capone")
    invoice     = Invoice.create(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
    transaction = Transaction.create(credit_card_number: "4654405418249632", result: "success", invoice_id: invoice.id)

    get :invoice, format: :json, id: transaction.id

    json_invoice = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(json_invoice[:id]).to eq(invoice.id)
  end
end

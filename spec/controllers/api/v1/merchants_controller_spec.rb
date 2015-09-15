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
end
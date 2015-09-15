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
end
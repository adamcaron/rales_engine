require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  scenario "#show" do
    merchant = Merchant.create(name: "Alfonse Capone")
    Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)

    get :show, format: :json, id: Item.first.id

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(item[:name]).to eq("Thing")
    expect(item[:description]).to eq("Awesome")
    expect(item[:unit_price]).to eq("100000.00")
    expect(item[:merchant_id]).to eq(merchant.id)
  end

  scenario "#find" do
    merchant = Merchant.create(name: "Alfonse Capone")
    item = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)

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
end
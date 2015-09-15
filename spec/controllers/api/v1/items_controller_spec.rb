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

  scenario "#find_all" do
    merchant = Merchant.create(name: "Alfonse Capone")
    item1 = Item.create(name: "Thing", description: "Awesome", unit_price: "4500.00", merchant_id: merchant.id)
    item2 = Item.create(name: "Thing", description: "Awesome", unit_price: "4500.00", merchant_id: merchant.id)
    item3 = Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00", merchant_id: merchant.id)

    get :find_all, format: :json, unit_price: "4500.00"
    json_items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:success)
    expect(json_items.count).to eq(2)
    expect(json_items.first[:unit_price]).to eq("4500.00")
    expect(json_items.last[:unit_price]).to eq("4500.00")
  end

  scenario "#random" do
    merchant = Merchant.create(name: "Alfonse Capone")
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
end
require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  scenario "#show" do
    Item.create(name: "Thing", description: "Awesome", unit_price: "100000.00")

    get :show, format: :json, id: Item.first.id

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:success)
    expect(item[:name]).to eq("Thing")
    expect(item[:description]).to eq("Awesome")
    expect(item[:unit_price]).to eq("100000.00")
  end
end

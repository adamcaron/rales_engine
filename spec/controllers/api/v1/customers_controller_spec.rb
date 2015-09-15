require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  scenario "#show" do
    customer = create(:customer)
    get :show, format: :json, id: Customer.first.id

    expect(response).to have_http_status(:success)
    expect(customer.first_name).to eq("John")
    expect(customer.last_name).to eq("Doe")
  end
end

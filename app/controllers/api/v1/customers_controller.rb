class Api::V1::CustomersController < ApplicationController
  respond_to :json

  def show
    respond_with Customer.find_by(id: params[:id])
  end

  def find
    respond_with Customer.find_by(customer_params)
  end

  def find_all
    if params.include?("first_name")
      respond_with Customer.where(first_name: params[:first_name])
    else params.inlude?("last_name")
      respond_with Customer.where(last_name: params[:last_name])
    end
  end

  def random
    customer = Customer.all.sample
    respond_with Customer.find_by(id: customer.id)
  end

  private

  def customer_params
    params.permit(:id, :first_name, :last_name)
  end
end
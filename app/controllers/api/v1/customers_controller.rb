class Api::V1::CustomersController < ApplicationController
  respond_to :json

  def show
    respond_with Customer.find_by(id: params[:id])
  end

  def find
    respond_with Customer.find_by(customer_params)
  end

  def find_all
    respond_with Customer.where(customer_params)
  end

  def random
    customer = Customer.all.sample
    respond_with Customer.find_by(id: customer.id)
  end

  def invoices
    respond_with Invoice.where(customer_id: params[:id])
  end

  private

  def customer_params
    params.permit(:id, :first_name, :last_name)
  end
end
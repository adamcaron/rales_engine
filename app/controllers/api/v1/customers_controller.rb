class Api::V1::CustomersController < ApplicationController
  respond_to :json

  def index
    respond_with Customer.all
  end

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

  def transactions
    respond_with Customer.find_by(customer_params).transactions
  end

  private

  def customer_params
    params.permit(:id, :first_name, :last_name, :updated_at, :created_at)
  end
end
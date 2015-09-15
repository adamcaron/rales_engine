class Api::V1::CustomersController < ApplicationController
  respond_to :json

  def show
    respond_with Customer.find_by(id: params[:id])
  end

  def find
    if params.include?("first_name")
      respond_with Customer.find_by(first_name: params[:first_name])
    elsif params.include?("last_name")
      respond_with Customer.find_by(last_name: params[:last_name])
    else
      respond_with Customer.find_by(id: params[:id])
    end
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
end
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
end
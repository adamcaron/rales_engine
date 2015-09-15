class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def show
    respond_with Merchant.find_by(id: params[:id])
  end

  def find
    if params.include?("name")
      respond_with Merchant.find_by(name: params[:name])
    else
      respond_with Merchant.find_by(id: params[:id])
    end
  end
end

class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def show
    respond_with Merchant.find_by(id: params[:id])
  end

  def find
    respond_with Merchant.find_by(merchant_params)
  end

  def find_all
    respond_with Merchant.where(name: params[:name]) if params.include?("name")
  end

  private

  def merchant_params
    params.permit(:id, :name)
  end
end

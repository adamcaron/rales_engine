class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def show
    respond_with Merchant.find_by(id: params[:id])
  end

  def find
    respond_with Merchant.find_by(merchant_params)
  end

  def find_all
    respond_with Merchant.where(merchant_params)
  end

  def random
    merchant = Merchant.all.sample
    respond_with Merchant.find_by(id: merchant.id)
  end

  private

  def merchant_params
    params.permit(:id, :name)
  end
end

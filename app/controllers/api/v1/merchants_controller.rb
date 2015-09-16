class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def index
    respond_with Merchant.all
  end

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

  def items
    respond_with Item.where(merchant_id: params[:id])
  end

  def invoices
    respond_with Invoice.where(merchant_id: params[:id])
  end

  def most_revenue
    # binding.pry
    # params[:quantity]
    respond_with Merchant.all.sort_by { |merchant| merchant.revenue }.reverse.take(params[:quantity])
    # respond_with Merchant
    # .take(params[:quantity])
  end

  private

  def merchant_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end

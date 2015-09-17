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
    top_earners = params["quantity"].to_i
    respond_with Merchant.all.sort_by { |merchant| merchant.revenue }.reverse.take(top_earners)
  end

  def most_items
    top_sellers = params["quantity"].to_i
    respond_with Merchant.all.sort_by { |merchant| merchant.items_sold }.reverse.take(top_sellers)
  end

  def revenue
    if params[:date]
      respond_with Merchant.revenue_by_date(params)
    else
      respond_with Merchant.single_merchant_total_revenue(params)
    end
  end

  private

  def merchant_params
    params.permit(:id, :name, :created_at, :updated_at, :date)
  end
end

class Api::V1::ItemsController < ApplicationController
  respond_to :json

  def index
    respond_with Item.all
  end

  def show
    respond_with Item.find_by(id: params[:id])
  end

  def find
    respond_with Item.find_by(item_params)
  end

  def find_all
    respond_with Item.where(item_params)
  end

  def random
    item = Item.all.sample
    respond_with Item.find_by(id: item.id)
  end

  def invoice_items
    respond_with InvoiceItem.where(item_id: params[:id])
  end

  def merchant
    merchant_id = Item.find_by(id: params[:id]).merchant_id
    respond_with Merchant.find_by(id: merchant_id)
  end

  def most_revenue
    top_items = params["quantity"].to_i
    respond_with Item.all.sort_by { |item| item.revenue }.reverse.take(top_items)
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end

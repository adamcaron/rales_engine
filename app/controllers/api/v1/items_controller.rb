class Api::V1::ItemsController < ApplicationController
  respond_to :json

  def show
    respond_with Item.find_by(id: params[:id])
  end

  def find
    respond_with Item.find_by(item_params)
  end

  def find_all
    if params.include?("description")
      respond_with Item.where(description: params[:description])
    elsif params.include?("unit_price")
      respond_with Item.where(unit_price: params[:unit_price])
    else params.include?("merchant_id")
      respond_with Item.where(merchant_id: params[:merchant_id])
    end
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end

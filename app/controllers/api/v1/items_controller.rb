class Api::V1::ItemsController < ApplicationController
  respond_to :json

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

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end

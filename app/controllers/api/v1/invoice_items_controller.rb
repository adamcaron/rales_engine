class Api::V1::InvoiceItemsController < ApplicationController
  respond_to :json

  def show
    respond_with InvoiceItem.find_by(id: params[:id])
  end

  def find
    respond_with InvoiceItem.find_by(invoice_item_params)
  end

  def find_all
    if params.include?("quantity")
      respond_with InvoiceItem.where(quantity: params[:quantity])
    elsif params.where?("unit_price")
      respond_with InvoiceItem.where(unit_price: params[:unit_price])
    elsif params.include?("item_id")
      respond_with InvoiceItem.where(item_id: params[:item_id])
    else params.include?("invoice_id")
      respond_with InvoiceItem.where(invoice_id: params[:invoice_id])
    end
  end

  private

  def invoice_item_params
    params.permit(:id, :quantity, :unit_price, :item_id, :invoice_id)
  end
end

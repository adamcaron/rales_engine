class Api::V1::InvoiceItemsController < ApplicationController
  respond_to :json

  def show
    respond_with InvoiceItem.find_by(id: params[:id])
  end

  def find
    if params.include?("quantity")
      respond_with InvoiceItem.find_by(quantity: params[:quantity])
    elsif params.include?("unit_price")
      respond_with InvoiceItem.find_by(unit_price: params[:unit_price])
    elsif params.include?("item_id")
      respond_with InvoiceItem.find_by(item_id: params[:item_id])
    elsif params.include?("invoice_id")
      respond_with InvoiceItem.find_by(invoice_id: params[:invoice_id])
    else
      respond_with InvoiceItem.find_by(id: params[:id])
    end
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
end

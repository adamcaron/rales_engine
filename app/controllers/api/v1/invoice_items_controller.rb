class Api::V1::InvoiceItemsController < ApplicationController
  respond_to :json

  def show
    respond_with InvoiceItem.find_by(id: params[:id])
  end

  def find
    respond_with InvoiceItem.find_by(invoice_item_params)
  end

  def find_all
    respond_with InvoiceItem.where(invoice_item_params)
  end

  def random
    invoice_item = InvoiceItem.all.sample
    respond_with InvoiceItem.find_by(id: invoice_item.id)
  end

  def invoice
    invoice_id = InvoiceItem.find_by(id: params[:id]).invoice_id
    respond_with Invoice.find_by(id: invoice_id)
  end

  def item
    item_id = InvoiceItem.find_by(id: params[:id]).item_id
    respond_with Item.find_by(id: item_id)
  end

  private

  def invoice_item_params
    params.permit(:id, :quantity, :unit_price, :item_id, :invoice_id)
  end
end

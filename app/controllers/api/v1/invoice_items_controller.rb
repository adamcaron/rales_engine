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

  private

  def invoice_item_params
    params.permit(:id, :quantity, :unit_price, :item_id, :invoice_id)
  end
end

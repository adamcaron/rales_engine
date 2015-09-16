class Api::V1::InvoicesController < ApplicationController
  respond_to :json

  def index
    respond_with Invoice.all
  end

  def show
    respond_with Invoice.find_by(id: params[:id])
  end

  def find
    respond_with Invoice.find_by(invoice_params)
  end

  def find_all
    respond_with Invoice.where(invoice_params)
  end

  def random
    invoice = Invoice.all.sample
    respond_with Invoice.find_by(id: invoice.id)
  end

  def transactions
    respond_with Transaction.where(invoice_id: params[:id])
  end

  def invoice_items
    respond_with InvoiceItem.where(invoice_id: params[:id])
  end

  def items
    respond_with Invoice.find_by(id: params[:id]).items
  end

  def customer
    customer_id = Invoice.find_by(id: params[:id]).customer_id
    respond_with Customer.find_by(id: customer_id)
  end

  def merchant
    merchant_id = Invoice.find_by(id: params[:id]).merchant_id
    respond_with Merchant.find_by(id: merchant_id)
  end

  private

  def invoice_params
    params.permit(:id, :status, :customer_id, :merchant_id, :created_at, :updated_at)
  end
end
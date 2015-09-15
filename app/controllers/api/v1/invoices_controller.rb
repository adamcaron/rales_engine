class Api::V1::InvoicesController < ApplicationController
  respond_to :json

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

  private

  def invoice_params
    params.permit(:id, :status, :customer_id, :merchant_id)
  end
end
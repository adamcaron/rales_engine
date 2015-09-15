class Api::V1::InvoicesController < ApplicationController
  respond_to :json

  def show
    respond_with Invoice.find_by(id: params[:id])
  end

  def find
    respond_with Invoice.find_by(invoice_params)
  end

  def find_all
    if params.include?("status")
      respond_with Invoice.where(status: params[:status])
    elsif params.include?("customer_id")
      respond_with Invoice.where(customer_id: params[:customer_id])
    else params.include?("merchant_id")
      respond_with Invoice.where(merchant_id: params[:merchant_id])
    end
  end

  private

  def invoice_params
    params.permit(:id, :status, :customer_id, :merchant_id)
  end
end
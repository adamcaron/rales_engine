class Api::V1::InvoicesController < ApplicationController
  respond_to :json

  def show
    respond_with Invoice.find_by(id: params[:id])
  end

  def find
    if params.include?("status")
      respond_with Invoice.find_by(status: params[:status])
    elsif params.include?("customer_id")
      respond_with Invoice.find_by(customer_id: params[:customer_id])
    elsif params.include?("merchant_id")
      respond_with Invoice.find_by(merchant_id: params[:merchant_id])
    else
      respond_with Invoice.find_by(id: params[:id])
    end
  end
end
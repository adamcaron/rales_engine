class Api::V1::TransactionsController < ApplicationController
  respond_to :json

  def show
    respond_with Transaction.find_by(id: params[:id])
  end

  def find
    respond_with Transaction.find_by(transaction_params)
  end

  def find_all
    if params.include?("credit_card_number")
      respond_with Transaction.where(credit_card_number: params[:credit_card_number])
    elsif params.where?("result")
      respond_with Transaction.where(result: params[:result])
    else params.include?("invoice_id")
      respond_with Transaction.where(invoice_id: params[:invoice_id])
    end
  end

  private

  def transaction_params
    params.permit(:credit_card_number, :result, :invoice_id)
  end
end

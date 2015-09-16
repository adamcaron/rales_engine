class Api::V1::TransactionsController < ApplicationController
  respond_to :json

  def index
    respond_with Transaction.all
  end

  def show
    respond_with Transaction.find_by(id: params[:id])
  end

  def find
    respond_with Transaction.find_by(transaction_params)
  end

  def find_all
    respond_with Transaction.where(transaction_params)
  end

  def random
    transaction = Transaction.all.sample
    respond_with Transaction.find_by(id: transaction.id)
  end

  def invoice
    invoice_id = Transaction.find_by(id: params[:id]).invoice_id
    respond_with Invoice.find_by(id: invoice_id)
  end

  private

  def transaction_params
    params.permit(:id, :credit_card_number, :result, :invoice_id, :created_at, :updated_at)
  end
end

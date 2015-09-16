class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  def revenue
    invoices.successful.joins(:invoice_items).sum("unit_price * quantity")
  end

  def items_sold
    invoices.successful.joins(:invoice_items).sum("quantity")
  end

end
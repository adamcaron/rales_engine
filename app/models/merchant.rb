class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  def revenue(date = nil)
    if date
      invoices.successful.where(created_at: date).joins(:invoice_items).sum("unit_price * quantity")
    else
      invoices.successful.joins(:invoice_items).sum("unit_price * quantity")
    end
  end

  def items_sold
    invoices.successful.joins(:invoice_items).sum("quantity")
  end
end
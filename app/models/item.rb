class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def revenue
    invoices.successful.sum('invoice_items.quantity * invoice_items.unit_price')
  end
end

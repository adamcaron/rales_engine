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

  def self.revenue_by_date(params)
    if params[:id]
      { revenue: self.all.inject(0) { |total, merchant| total + merchant.revenue(params[:date]) } }
    else
      { total_revenue: self.all.inject(0) { |total, merchant| total + merchant.revenue(params[:date]) } }
    end
  end

  def self.single_merchant_total_revenue(params)
    { revenue: self.find_by(id: params[:id]).revenue }
  end

  def items_sold
    invoices.successful.joins(:invoice_items).sum("quantity")
  end
end
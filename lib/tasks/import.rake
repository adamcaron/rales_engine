require 'csv'
require 'pry'

desc "Import teams from csv file"
task :import => [:environment] do

  # file = "db/teams.csv"

  # CSV.foreach(file, :headers => true) do |row|
  #   Team.create {
  #     :name => row[1],
  #     :league => row[2],
  #     :some_other_data => row[4]
  #   }
  # end

  @path          = "db/data/"
  models = %w(customer merchant invoice item invoice_item transaction)

  models.each do |m|
    CSV.foreach("#{@path}#{m.pluralize}.csv", headers: true) do |row|
      m = m.camelize.constantize unless m.is_a?(Class)
      m.create(row.to_h.except("id", "credit_card_expiration"))
    end
  end


# models.each do |m|
# => CSV.foreach(data_file, headers: true) do |row|
# m.create(row.to_h.except("id", "credit_card_expiration"))



  #  CSV.foreach(customers, headers: true) do |row|
  #   Customer.create({
  #     first_name: row[1],
  #      last_name: row[2],
  #     created_at: row[3],
  #     updated_at: row[4]
  #   })
  # end

  #  CSV.foreach(merchants, headers: true) do |row|
  #   Merchant.create({
  #           name: row[1],
  #     created_at: row[2],
  #     updated_at: row[3]
  #   })
  # end

  #  CSV.foreach(invoices, headers: true) do |row|
  #   Invoice.create({
  #     customer_id: row[1],
  #     merchant_id: row[2],
  #          status: row[3],
  #      created_at: row[4],
  #      updated_at: row[5]
  #   })
  # end

  #  CSV.foreach(items, headers: true) do |row|
  #   Item.create({
  #            name:  row[1],
  #     description:  row[2],
  #      unit_price:  row[3],
  #     merchant_id:  row[4],
  #      created_at:  row[5],
  #      updated_at:  row[6]
  #   })
  # end

  #  CSV.foreach(invoice_items, headers: true) do |row|
  #   InvoiceItem.create({
  #         item_id: row[1],
  #      invoice_id: row[2],
  #        quantity: row[3],
  #      unit_price: row[4],
  #      created_at: row[5],
  #      updated_at: row[6]
  #   })
  # end

  #  CSV.foreach(transactions, headers: true) do |row|
  #   Transaction.create({
  #     invoice_id:  row[1],
  #     credit_card_number: row[2],
  #     result:  row[4],
  #     created_at: row[5],
  #     updated_at: row[6]
  #   })
  # end

end
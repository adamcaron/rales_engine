require 'csv'

desc "Import 'Rales Engine' data from csv file"
task :import => [:environment] do

  @path          = "db/data/"
  models = %w(customer merchant invoice item invoice_item transaction)

  models.each do |m|
    CSV.foreach("#{@path}#{m.pluralize}.csv", headers: true) do |row|
      m = m.camelize.constantize unless m.is_a?(Class)
      row = row.to_h
      row["unit_price"] = BigDecimal.new((row["unit_price"].to_f / 100).to_s) unless row["unit_price"].nil?
      m.create(row.except("id", "credit_card_expiration_date"))
    end
  end
end
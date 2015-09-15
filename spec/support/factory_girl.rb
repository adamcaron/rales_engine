require 'factory_girl_rails'
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  factory :customer do
    first_name "John"
    last_name  "Doe"
  end

  factory :merchant do
    name "Lemony Snicket"
  end

  factory :invoice do
    status "shipped"
    cusomter_id "5"
    merchant_id "26"
  end

  factory :item do
    name "Awesome Item"
    description  "Pretty cool"
    unit_price "100.00"
    merchant_id "4"
  end

  factory :invoice_item do
    quantity 7
    unit_price "250.00"
    item_id "6"
    invoice_id "17"
  end

  factory :transaction do
    credit_card_number "4397199533314394"
    result "success"
    invoice_id "17"
  end
end
FactoryBot.define do
  factory :subscription do
    title { Faker::Tea.variety }
    price { Faker::Number.decimal(l_digits: (rand(1..2)), r_digits: 2) }
    active { true }
    frequency { Faker::Number.within(range: 0..3) }
    customer_id { Faker::Number.within(range: Customer.minimum(:id)..Customer.maximum(:id)) }
    tea_id { Faker::Number.within(range: Tea.minimum(:id)..Tea.maximum(:id)) }
  end
end

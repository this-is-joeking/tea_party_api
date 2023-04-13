# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do
  Customer.create!({
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    address_line1: Faker::Address.street_address,
    address_line2: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    postal_code: Faker::Address.zip_code,
    country: "United States"
  })
end

10.times do
  Tea.create!({
    title: Faker::Tea.variety,
    description: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
    brewtime: Faker::Number.within(range: 1..15)
  })
end

30.times do
  Subscription.create!({
    title: Faker::Tea.variety,
    price: Faker::Number.decimal(l_digits: (rand(1..2)), r_digits: 2),
    active: Faker::Boolean.boolean(true_ratio: 0.75),
    frequency: Faker::Number.within(range: 0..3),
    customer_id: Faker::Number.within(range: Customer.minimum(:id)..Customer.maximum(:id)),
    tea_id: Faker::Number.within(range: Tea.minimum(:id)..Tea.maximum(:id))
  })
end
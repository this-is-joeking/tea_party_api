FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4) }
    brewtime { Faker::Number.within(range: 1..15) }
  end
end

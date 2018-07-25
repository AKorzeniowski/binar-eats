FactoryBot.define do

  factory :user do
    nickname 'nick'
    email Faker::Internet.email('nick')
    password Faker::Internet.password
    account_number Faker::Number.number(26)

    trait :creator do
      nickname 'creator'
      email Faker::Internet.email('creator')
      password Faker::Internet.password
      account_number Faker::Number.number(26)
    end

    trait :orderer do
      nickname 'orderer'
      email Faker::Internet.email('orderer')
      password Faker::Internet.password
      account_number Faker::Number.number(26)
    end

    trait :deliverer do
      nickname 'deliverer'
      email Faker::Internet.email('deliverer')
      password Faker::Internet.password
      account_number Faker::Number.number(26)
    end

    trait :creator1 do
      email Faker::Internet.email('creator1')
    end


  end
end

FactoryBot.define do

  factory :user01 do
    nickname Faker::Internet.username
    email Faker::Internet.email
    password Faker::Internet.password
    account_number Faker::Number.number(26)
  end

  factory :user02 do
    nickname Faker::Internet.username
    email Faker::Internet.email
    password Faker::Internet.password
    account_number Faker::Number.number(26)
  end
end

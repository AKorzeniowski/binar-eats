FactoryBot.define do
  factory :order do
    deadline 3.hours.from_now

    association :creator, :creator, factory: :user
    orderer { creator }
    association :deliverer, :deliverer, factory: :user
    association :place
  end
end

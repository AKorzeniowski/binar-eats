FactoryBot.define do
  factory :item do
    food 'Smaczne jedzonko.'
    cost 12.50

    association :order
    association :user
  end
end

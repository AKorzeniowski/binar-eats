FactoryBot.define do
  factory :order01 do
    creator_id user01
    place01
    deadline 3.hours.from_now
    orderer_id user01
    deliverer_id user02
  end
end

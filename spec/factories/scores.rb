FactoryGirl.define do
  factory :score do
    initials 'ABC'
    value 15000
    sequence(:ip_address) {|n| "127.0.0.#{n}" }
  end
end

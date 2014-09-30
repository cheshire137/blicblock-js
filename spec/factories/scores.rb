# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :score do
    initials "MyString"
    value 1
    latitude "9.99"
    longitude "9.99"
    ip_address "MyString"
  end
end

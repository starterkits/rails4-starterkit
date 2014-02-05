FactoryGirl.define do
  factory :user do
    email       { Faker::Internet.email }
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    password    { Faker::DizzleIpsum.words(4).join('!').first(20) }
  end
end

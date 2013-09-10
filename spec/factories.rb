def length_at_least(count)
  begin
    result = yield
  end while result.length < count
  result
end

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Company.name.first(15) }
  end

  factory :authentication do
    association :user
    provider { %w[twitter facebook linkedin].sample }
    proid { SecureRandom.hex }
    token {
      t = SecureRandom.hex
      t[8] = '-'
      t
    }
  end
end

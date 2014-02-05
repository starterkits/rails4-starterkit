FactoryGirl.define do
  factory :authentication do
    user
    provider { %w[twitter facebook linkedin].sample }
    proid { SecureRandom.hex }
    token {
      t = SecureRandom.hex
      t[8] = '-'
      t
    }
  end
end

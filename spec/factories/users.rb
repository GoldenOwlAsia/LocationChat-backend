FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  trait :blank_email do
    email ''
  end

  trait :blank_password do
    password ''
  end

  trait :blank_password_confirmation do
    password_confirmation ''
  end
end

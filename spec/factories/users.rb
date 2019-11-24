FactoryBot.define do
	sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    email { generate :email }
    password { "asdfasdf" }
    password_confirmation { "asdfasdf" }
    confirmed_at { Time.zone.now }
  end

  factory :second_user, class: User do
    email { generate :email }
    password { "asdfasdf" }
    password_confirmation { "asdfasdf" }
    confirmed_at { Time.zone.now }
  end
end

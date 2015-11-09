FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@test.com"
    end
    password "1234abcd"
    password_confirmation "1234abcd"
  end
end

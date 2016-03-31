FactoryGirl.define do
  factory :user do
    name      "Miros"
    email     "miros@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end
FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@test.com"}
    password "foobar"
    password_confirmation "foobar"
  end
  
  factory :micropost do
    content "Test post"
    user
  end
end
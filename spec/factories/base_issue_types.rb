FactoryBot.define do
    factory :base_issue_type do
      name { Faker::Lorem.word }
      association :base_location_type
    end
  end
FactoryGirl.define do
  factory :phone do
    kind 'home'
    sequence(:area_code, 111) { |n| "#{n}"}
    sequence(:number, 1111111) { |n| "#{n}"}
    sequence(:extension) { |n| "#{n}"}


    trait :without_kind do
      kind ' '
    end

    trait :without_area_code do
      area_code ' '
    end

    trait :without_number do
      number ' '
    end

    factory :invalid_phone, traits: [:without_kind, :without_area_code, :without_number]

  end
end
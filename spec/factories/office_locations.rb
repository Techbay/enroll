FactoryGirl.define do
  factory :office_location do

    is_primary  true
    address { FactoryGirl.build(:address, kind: "work") }
    phone   { FactoryGirl.build(:phone, kind: "work") }
    email   { FactoryGirl.build(:email, kind: "work") }
    
  end
end

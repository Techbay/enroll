require 'rails_helper'

# Class methods
describe Person, '.new', type: :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }

  # it 'should validate uniqueness of :ssn' do
  #   expect(subject).to validate_uniqueness_of :ssn
  # end

  it 'properly intantiates the class' do
    person = Person.new(
        name_pfx: "mr",
        first_name: "paxton",
        middle_name: "x",
        last_name: "thomas",
        name_sfx: "III"
      )

    expect(person.errors.size).to eq 0
  end
end

describe Person, '.active', type: :model do
  it 'returns only active users' do
    # setup
    active_person = Person.create!(first_name: "joe", last_name: "cool", is_active: true)
    non_active_person_1 = Person.create!(first_name: "billy", last_name: "uncool", is_active: false)
    non_active_person_2 = Person.create!(first_name: "mary", last_name: "uncool", is_active: false)

    ap = Person.active

    expect(ap.size).to eq 1
    expect(ap).to eq [active_person]
  end
end

describe Person, '.addresses', type: :model do
  it 'accepts associated addresses' do
    # setup
    person = Person.new(
        first_name: "joe", 
        last_name: "cool", 
        addresses: [Address.new(
            kind: "home",
            address_1: "1600 Pennsylvania Ave",
            city: "Washington",
            state: "DC",
            zip: "20001"
          )]
      )

    result = person.save

    expect(result).to eq true
    expect(person.addresses.first.kind).to eq "home"
  end
end

# Instance methods
describe Person, '#full_name' do
  it 'returns the concatenated name attributes' do
    p = Person.new(first_name: 'joe', middle_name: 's', last_name: 'cool')

    expect(p.full_name).to eq 'Joe S Cool'
  end
end

describe Person, '#home_phone' do
  it "sets and returns the person's home telephone number" do
    p = Person.new(
        first_name: 'christian',
        last_name: 'bale',
        phones_attributes: [{
          kind: 'home',
          area_code: '202',
          phone_number: '555-1212'
        }]
      )

    expect(p.home_phone.phone_number).to eq '5551212'
  end
end


describe Person, '#families' do
  it 'returns families where the person is present' do
  end
end
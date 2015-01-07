require 'rails_helper'

describe Employee, type: :model do
  it { should delegate_method(:hbx_assigned_id).to :person }
  it { should delegate_method(:ssn).to :person }
  it { should delegate_method(:dob).to :person }
  it { should delegate_method(:gender).to :person }

  it { should validate_presence_of :person }
  it { should validate_presence_of :ssn }
  it { should validate_presence_of :dob }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :employer_id }
  it { should validate_presence_of :date_of_hire }

  it 'properly intantiates the class using an existing person' do
    ssn = "987654321"
    date_of_hire = Date.today - 10.days
    dob = Date.today - 36.years
    gender = "female"

    employer = Employer.create(
        name: "ACME Widgets, Inc.",
        fein: "098765432",
        entity_kind: "c_corporation"
      )

    person = Person.create(
        first_name: "annie", 
        last_name: "lennox",
        addresses: [Address.new(
            kind: "home",
            address_1: "441 4th St, NW",
            city: "Washington",
            state: "DC",
            zip: "20001"
          )
        ]
      )

    employee = person.build_employee
    employee.ssn = ssn
    employee.dob = dob
    employee.gender = gender
    employee.employer_id = employer._id
    employee.date_of_hire = date_of_hire
    expect(employee.touch).to eq true

    # Verify local getter methods
    expect(employee.employer).to eq employer
    expect(employee.date_of_hire).to eq date_of_hire

    # Verify delegate local attribute values
    expect(employee.ssn).to eq ssn
    expect(employee.dob).to eq dob
    expect(employee.gender).to eq gender

    # Verify delegated attribute values
    expect(person.ssn).to eq ssn
    expect(person.dob).to eq dob
    expect(person.gender).to eq gender

    expect(employee.errors.messages.size).to eq 0
    expect(employee.save).to eq true
  end

  it 'properly intantiates the class using a new person' do
    ssn = "987654320"
    date_of_hire = Date.today - 10.days
    dob = Date.today - 26.years
    gender = "female"

    employer = Employer.create(
        name: "Ace Ventures, Ltd.",
        fein: "098765437",
        entity_kind: "s_corporation"
      )

    person = Person.new(first_name: "carly", last_name: "simon")

    employee = person.build_employee
    employee.ssn = ssn
    employee.dob = dob
    employee.gender = gender
    employee.employer_id = employer._id
    employee.date_of_hire = date_of_hire

    # Verify local getter methods
    expect(employee.employer).to eq employer
    expect(employee.date_of_hire).to eq date_of_hire

    # Verify delegate local attribute values
    expect(employee.ssn).to eq ssn
    expect(employee.dob).to eq dob
    expect(employee.gender).to eq gender

    # Verify delegated attribute values
    expect(person.ssn).to eq ssn
    expect(person.dob).to eq dob
    expect(person.gender).to eq gender

    expect(person.errors.messages.size).to eq 0
    expect(person.save).to eq true

    expect(employee.touch).to eq true
    expect(employee.errors.messages.size).to eq 0
    expect(employee.save).to eq true
  end

end
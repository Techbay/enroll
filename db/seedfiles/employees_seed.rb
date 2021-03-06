require 'factories/enrollment_factory'

puts "*"*80
puts "::: Creating Employee Roles:::"

Organization.all.collect{|org| org.employer_profile}.each do |employer_profile|
  employer = employer_profile
  if employer.present?
  employer.employee_families.each do |family|
    census_employee = family.census_employee
    person = Person.create!(
        first_name: census_employee.first_name,
        last_name: census_employee.last_name,
        addresses: [census_employee.address],
    )
    
    employee = EnrollmentFactory.add_employee_role(
      person: person,
      employer_census_family: family,
      gender: census_employee.gender,
      ssn: census_employee.ssn,
      dob: census_employee.dob,
      hired_on: census_employee.hired_on
    )
  end
  end
end

puts "::: Employees Complete :::"

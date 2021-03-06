require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { should validate_presence_of :legal_name }
  it { should validate_presence_of :fein }
  it { should validate_presence_of :office_locations }

  let(:legal_name) {"Acme Brokers, Inc"}
  let(:fein) {"065872626"}
  let(:bad_fein) {"123123"}
  let(:office_locations) {FactoryGirl.build(:office_locations)}

  let(:fein_error_message) {"#{bad_fein} is not a valid FEIN"}

  let(:valid_office_location_attributes) do
    {
      address: FactoryGirl.build(:address, kind: "work"),
      phone: FactoryGirl.build(:phone, kind: "work"),
      email: FactoryGirl.build(:email, kind: "work")
    }
  end

  let(:valid_params) do
    {
      legal_name: legal_name,
      fein: fein,
      office_locations: [valid_office_location_attributes]
    }
  end

  describe ".create" do
    context "with valid arguments" do
      let(:params) {valid_params}
      let(:organization) {Organization.create(**params)}
      before do
        organization.valid?
      end

      context "and a second organization is created with the same fein" do
        let(:organization2) {Organization.create(**params)}
        before do
          organization2.valid?
        end

        context "the second organization" do
          it "should not be valid" do
             expect(organization2.valid?).to be false
          end

          it "should have an error on fein" do
            expect(organization2.errors[:fein].any?).to be true
          end

          it "should not have the same id as the first organization" do
            expect(organization2.id).not_to eq organization.id
          end
        end
      end
    end
  end


  describe ".new" do

    context "with no arguments" do
      let(:params) {{}}

      it "should not save" do
        expect(Organization.new(**params).save).to be_false
      end
    end

    context "with all valid arguments" do
      let(:params) {valid_params}

      it "should save" do
        expect(Organization.new(**params).save).to be_true
      end
    end

    context "with no legal_name" do
      let(:params) {valid_params.except(:legal_name)}

      it "should fail validation" do
        expect(Organization.create(**params).errors[:legal_name].any?).to be_true
      end
    end

    context "with no fein" do
      let(:params) {valid_params.except(:fein)}

      it "should fail validation" do
        expect(Organization.create(**params).errors[:fein].any?).to be_true
      end
    end

    context "with no office_locations" do
      let(:params) {valid_params.except(:office_locations)}

      it "should fail validation" do
        expect(Organization.create(**params).errors[:office_locations].any?).to be_true
      end
    end

   context "with invalid fein" do
      let(:params) {valid_params.deep_merge({fein: bad_fein})}

      it "should fail validation" do
        expect(Organization.create(**params).errors[:fein]).to eq [fein_error_message]
      end
    end

  end
end

require 'rails_helper'

RSpec.describe BrokerAgencyProfile, type: :model do
  it { should validate_presence_of :market_kind }
  it { should validate_presence_of :primary_broker_role_id }

  it { should delegate_method(:hbx_id).to :organization }
  it { should delegate_method(:legal_name).to :organization }
  it { should delegate_method(:dba).to :organization }
  it { should delegate_method(:fein).to :organization }
  it { should delegate_method(:is_active).to :organization }
  it { should delegate_method(:updated_by).to :organization }


  let(:organization) {FactoryGirl.create(:organization)}
  let(:market_kind) {"both"}
  let(:bad_market_kind) {"commodities"}
  let(:primary_broker_role_id) {"8754985"}

  let(:market_kind_error_message) {"#{bad_market_kind} is not a valid market kind"}


  describe ".new" do

    let(:valid_params) do
      { 
        organization: organization,
        market_kind: market_kind,
        primary_broker_role_id: primary_broker_role_id,
      }
    end

    context "with no arguments" do
      let(:params) {{}}
       
      it "should not save" do
        expect(BrokerAgencyProfile.new(**params).save).to be_false
      end
    end
    
    context "with no organization" do
      let(:params) {valid_params.except(:organization)}

      it "should raise" do
        expect{BrokerAgencyProfile.new(**params).save}.to raise_error(Mongoid::Errors::NoParent)
      end
    end

    context "with no market_kind" do
      let(:params) {valid_params.except(:market_kind)}

      it "should fail validation" do
        expect(BrokerAgencyProfile.create(**params).errors[:market_kind].any?).to be_true
      end
    end

   context "with invalid market_kind" do
      let(:params) {valid_params.deep_merge({market_kind: bad_market_kind})}

      it "should fail validation" do
        expect(BrokerAgencyProfile.create(**params).errors[:market_kind]).to eq [market_kind_error_message]
      end
    end

    context "with no primary_broker" do
      let(:params) {valid_params.except(:primary_broker_role_id)}
    
      it "should fail validation" do
        expect(BrokerAgencyProfile.create(**params).errors[:primary_broker_role_id].any?).to be_true
      end
    end

    context "with all valid arguments" do
      let(:params) {valid_params}
       
      it "should save" do
        expect(BrokerAgencyProfile.new(**params).save!).to be_true
      end
    end

  end
end

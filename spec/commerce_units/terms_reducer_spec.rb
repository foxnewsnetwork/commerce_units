require 'spec_helper'

describe CommerceUnits::TermsReducer do
  before { CommerceUnits::LengthFactory.everything }
  let(:one_centimeter_kilometer_per_meter) { CommerceUnits::Value.from_params number: 1, units: "centimeter * kilometer / meter" }
  let(:centimeter) { CommerceUnits::LengthFactory.centimeter.to_unit }
  let(:reducer) { described_class.new one_centimeter_kilometer_per_meter }
  context '#reduce_to_simplest_terms' do
    let(:actual) { CommerceUnits::Converter.convert unit: centimeter, value: reducer.reduce_to_simplest_terms }
    let(:expected) { CommerceUnits::Value.from_params number: 1000, units: "centimeter" }
    subject { actual }
    specify { should eq expected }
    context '#to_s' do
      subject { actual.to_s }
      specify { should eq "1000.0 centimeter"}
    end
  end
end
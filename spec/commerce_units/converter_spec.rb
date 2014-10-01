require 'spec_helper'

describe CommerceUnits::Converter do
  before { @lengths = CommerceUnits::LengthFactory.everything }
  let(:centimeter) { CommerceUnits::LengthFactory.centimeter }
  let(:meter) { CommerceUnits::LengthFactory.meter }
  context 'factory' do
    subject { CommerceUnits::Dimension.find_by_unit_name "centimeter" }
    specify { should eq centimeter }
  end
  context '#coerce' do
    let(:target_unit) { centimeter.to_unit }
    let(:origin_unit) { meter.to_unit }
    let(:origin_value) { CommerceUnits::Value.new 987, origin_unit }
    let(:expected_value) { CommerceUnits::Value.new 98700, target_unit }
    let(:converter) do
      described_class.new.tap do |c|
        c.target_unit = target_unit
        c.origin_value = origin_value
      end
    end
    subject { converter.coerce }
    specify { should be_a CommerceUnits::Value }
    specify { should eq expected_value }
    context '#number' do
      subject { converter.coerce.number }
      specify { should be_a Numeric }
      specify { should eq expected_value.number }
    end

    context '#unit' do
      subject { converter.coerce.unit }
      specify { should eq expected_value.unit }
    end
  end

end
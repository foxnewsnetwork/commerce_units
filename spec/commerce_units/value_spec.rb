require 'spec_helper'

describe CommerceUnits::Value do
  before do 
    CommerceUnits::LengthFactory.everything
    CommerceUnits::TimeFactory.everything
  end
  let(:centimeter) { CommerceUnits::LengthFactory.centimeter }
  let(:inch) { CommerceUnits::LengthFactory.inch }
  let(:meter) { CommerceUnits::LengthFactory.meter }
  let(:day) { CommerceUnits::TimeFactory.day }
  let(:week) { CommerceUnits::TimeFactory.week }
  let(:one_week) { CommerceUnits::Value.new 1, week.to_unit }
  let(:one_centimeter) { CommerceUnits::Value.new 1, centimeter.to_unit }
  let(:one_meter) { CommerceUnits::Value.new 1, meter.to_unit }  
  let(:one_day) { CommerceUnits::Value.new 1, day.to_unit }
  context '#+' do
    let(:actual) { one_centimeter + one_meter }
    let(:expected) { CommerceUnits::Value.new 101, centimeter.to_unit }
    subject { actual }
    specify { should eq expected }
    context 'apples and oranges' do
      it 'should raise an error' do
        expect { one_day + one_meter }.to raise_error
      end
    end
  end

  context ':from_params' do
    let(:actual) { CommerceUnits::Value.from_params number: 1234, units: "centimeter / day" }
    let(:one_centimeter_per_day) { one_centimeter / one_day }
    let(:expected) { CommerceUnits::Value.new 1234, one_centimeter_per_day.unit }
    subject { actual }
    specify { should eq expected }
    context '#to_s' do
      subject { actual.to_s }
      specify { should eq "1234 centimeter / day" }
    end
  end

  context '#to_s' do
    subject { one_day.to_s }
    specify { should eq '1 day'}    
  end

  context '#*' do
    let(:one_day_meter) { one_day * one_meter }
    subject { one_day_meter.to_s }
    specify { should eq '1 day * meter'}
  end

  context '#/' do
    let(:one_meter_per_day) { one_meter / one_day }
    subject { one_meter_per_day.to_s }
    specify { should eq '1 meter / day'}
  end

  context '#+ complicated' do
    let(:one_centimeter_per_day) { one_centimeter / one_day }
    let(:one_meter_per_week) { one_meter / one_week }
    let(:actual) { one_centimeter_per_day + one_meter_per_week }
    let(:number) { BigDecimal.new 1.0 + 100.0 / 7.0, 9 }
    let(:expected) { CommerceUnits::Value.new number, one_centimeter_per_day.unit }
    subject { actual }
    specify { should eq expected }
    context '#to_s' do
      subject { actual.to_s }
      specify { should eq '15.2857143 centimeter / day' }
    end
  end
end
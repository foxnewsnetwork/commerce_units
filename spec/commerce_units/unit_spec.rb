require 'spec_helper'

describe CommerceUnits::Unit do
  let(:inch) { CommerceUnits::LengthFactory.inch }
  let(:centimeter) { CommerceUnits::LengthFactory.centimeter }
  before { centimeter }
  context '#==' do
    let(:another_inch) { CommerceUnits::Unit.new.tap { |u| u.numerator = ["inch"] } }
    subject { inch.to_unit }
    specify { should be_a described_class }
    specify { should eq another_inch }
    specify { should_not eq centimeter.to_unit }
  end

end
require 'spec_helper'

describe CommerceUnits::UnitParser do
  let(:source) { 'meter * USD / hour / container' }
  context '#parser' do
    let(:expected) do
      CommerceUnits::Unit.new.tap do |u|
        u.numerator = ["meter", "USD"]
        u.denominator = ['hour', 'container']
      end
    end
    subject { described_class.parse source }
    specify { should eq expected }
  end
end
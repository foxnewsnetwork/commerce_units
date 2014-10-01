require 'spec_helper'

describe CommerceUnits::Simplifier do
  before do
    @numerator = [1,1,1,2,2,3,4,4,5,6,7]
    @denominator = [1,2,5,6,9]
  end
  let(:simplifier) { described_class.new numerator: @numerator, denominator: @denominator }
  let(:expected) { [1,1,2,3,4,4,7] }
  context '#numerator' do
    subject { simplifier.numerator }
    specify { should eq expected }
  end
  context '#denominator' do
    subject { simplifier.denominator }
    specify { should eq [9] }
  end
  context '#_reduced_numerator_from' do
    subject { simplifier.send '_reduced_numerator_from', top: @numerator, bot: @denominator }
    specify { should eq expected }
  end
end
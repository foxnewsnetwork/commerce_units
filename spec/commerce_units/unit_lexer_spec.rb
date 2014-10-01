require 'spec_helper'

describe CommerceUnits::UnitLexer do
  context 'standard #tokenize' do
    let(:source) { "day * meter / metric ton" }
    let(:expected) { ['day', '*', 'meter', '/', 'metric ton'] }
    subject { described_class.tokenize source }
    specify { should eq expected }
  end

  context 'error #tokenize' do
    subject { lambda { described_class.tokenize "day * meter ** time" } }
    specify { should raise_error }
  end
end
# == Schema Information
#
# Table name: scientific_dimensions
#
#  id                :integer          not null, primary key
#  root_dimension    :string(255)      not null
#  unit_name         :string(255)      not null
#  unitary_role      :string(255)      default("tertiary"), not null
#  multiply_constant :decimal(15, 5)   default(1.0), not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe CommerceUnits::Dimension do
  let(:time1) { CommerceUnits::DimensionFactory.time_mock.make_primary! }
  let(:time2) { CommerceUnits::DimensionFactory.time_mock }
  let(:time3) { CommerceUnits::DimensionFactory.time_mock }
  let(:time4) { CommerceUnits::DimensionFactory.time_mock }
  let(:times) { [time1, time2, time3, time4] }
  context '#root_dimension' do
    specify { expect(time1.root_dimension).to eq time2.root_dimension }
    specify { expect(time2.root_dimension).to eq time3.root_dimension }
    specify { expect(time3.root_dimension).to eq time4.root_dimension }
  end
  context ':by_roots' do
    subject { described_class.by_roots(:time) }
    specify { should include times.first }
    specify { should include times.second }
    specify { should include times.third }
    specify { should include times.last }
  end
  context ':primary_unit_by_roots' do
    before { times }
    subject { described_class.primary_unit_by_roots(:time).first }
    specify { should eq time1 }
  end

end

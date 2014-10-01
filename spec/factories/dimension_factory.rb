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

class CommerceUnits::DimensionFactory < CommerceUnits::BaseFactory
  class << self
    def time_mock
      CommerceUnits::Dimension.find_or_create_and_consider_making_primary! root_dimension: "time",
        unit_name: Faker::Name.first_name,
        multiply_constant: rand(999) + 1
    end

    def length_mock
      CommerceUnits::Dimension.find_or_create_and_consider_making_primary! root_dimension: "length",
        unit_name: Faker::Name.first_name,
        multiply_constant: rand(999) + 1
    end

    def price_mock
      CommerceUnits::Dimension.find_or_create_and_consider_making_primary! root_dimension: "money",
        unit_name: Faker::Name.first_name,
        multiply_constant: rand(999) + 1
    end

    def mass_mock
      CommerceUnits::Dimension.find_or_create_and_consider_making_primary! root_dimension: "mass",
        unit_name: Faker::Name.first_name,
        multiply_constant: rand(999) + 1
    end  

  end
end

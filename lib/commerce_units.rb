require "functional_support"
require "commerce_units/version"
require "commerce_units/converter"
require "commerce_units/dimension"
require "commerce_units/simplifier"
require "commerce_units/terms_reducer"
require "commerce_units/unit"
require "commerce_units/unit_lexer"
require "commerce_units/unit_parser"
require "commerce_units/value"
module CommerceUnits
  def self.table_name_prefix
    "commerce_units_"
  end
  def self.dimensional_database
    @dimensional_database ||= CommerceUnits::Dimension
  end
  def self.dimensional_database=(some_sort_of_class)
    @dimensional_database = some_sort_of_class
  end
  def self.nt(number, unit)
    CommerceUnits::Value.from_params number: number, unit: unit
  end
end

# A helpful alias, but if and only if it isn't already used
CU = CommerceUnits unless defined?(CU)
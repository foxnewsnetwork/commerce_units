class CommerceUnits::Value
  class << self
    def from_params(number: number, units: units)
      new number, CommerceUnits::UnitParser.parse(units)
    end
  end
  delegate :unitless?,
    to: :unit
  attr_accessor :number, :unit
  def initialize(number=nil, unit=nil)
    @number = number
    @unit = unit
  end

  def +(value)
    v = _convert_units_to_match value
    self.class.new v.number + number, unit
  end

  def -(value)
    v = _convert_units_to_match value
    self.class.new number - v.number, unit
  end

  def *(value)
    self.class.new number * value.number, CommerceUnits::Unit.multiply(unit, value.unit)
  end

  def /(value)
    self.class.new number / value.number, CommerceUnits::Unit.divide(unit, value.unit)
  end

  def flip
    self.class.new.tap do |v|
      v.number = 1.0 / number
      v.unit = unit.flip
    end
  end

  def simplify
    CommerceUnits::TermsReducer.new(self).reduce_to_simplest_terms
  end

  def ==(value)
    v = _convert_units_to_match value
    number == v.number && unit == v.unit
  end

  def to_s
    "#{number} #{unit.pretty_inspect}"
  end

  def constant?; unitless; end

  private
  def _convert_units_to_match(value)
    CommerceUnits::Converter.new.tap do |c|
      c.target_unit = self.unit
      c.origin_value = value
    end.coerce
  end
end
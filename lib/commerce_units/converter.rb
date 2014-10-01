class CommerceUnits::Converter
  class << self
    def convert(value: value, unit: unit)
      new.tap do |c|
        c.target_unit = unit
        c.origin_value = value
      end.coerce
    end
  end
  class MismatchDimension < StandardError; end
  class WrongType < StandardError; end
  attr_reader :target_unit, :origin_value
  
  def coerce
    return origin_value if target_unit == origin_unit
    raise MismatchDimension, "Unable to convert #{origin_unit} to #{target_unit}" if _mismatch_dimension?
    _base_to_target_transform _origin_to_base_transform origin_value
  end

  def origin_unit
    origin_value.unit
  end

  def target_unit=(unit)
    raise WrongType, "#{unit} should be an instance of CommerceUnits::Unit" unless unit.is_a? CommerceUnits::Unit
    @target_unit = unit
  end

  def origin_value=(value)
    raise WrongType, "#{value} should be an instance of CommerceUnits::Value" unless value.is_a? CommerceUnits::Value
    @origin_value = value
  end

  private

  def _origin_to_base_transform(value)
    _conversion_constants(origin_unit).inject(value) { |v, c| v * c }
  end

  def _conversion_constants(unit)
    CommerceUnits.dimensional_database.from_array_of_unit_names!(unit.numerator).map(&:to_converter_value) + 
      CommerceUnits.dimensional_database.from_array_of_unit_names!(unit.denominator).map(&:to_converter_value).map(&:flip)
  end

  def _base_to_target_transform(value)
    _conversion_constants(target_unit).inject(value) { |v,c| v * c }
  end

  def _mismatch_dimension?
    not _matching_dimension?
  end

  def _matching_dimension?
    target_unit.to_root_dimension == origin_unit.to_root_dimension
  end
end

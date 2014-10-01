class CommerceUnits::TermsReducer
  attr_accessor :value
  delegate :number, :unit, to: :value
  def initialize(value)
    @value = value
  end

  def reduce_to_simplest_terms
    _reducing_terms.reduce(value, &:*)
  end

  private
  def _reducing_terms
    _units_by_dimensions.flat_map do |root_dimension, numerators_and_denominators|
      numerators_and_denominators[:numerators].zip numerators_and_denominators[:denominators]
    end.reject do |top_and_bottom|
      top_and_bottom.first.blank? || top_and_bottom.last.blank?
    end.map do |top_and_bottom|
      _value_from_ratio *top_and_bottom
    end
  end

  def _units_by_dimensions
    _special_merge _numerator_by_dimensions, _denominator_by_dimensions  
  end

  def _special_merge(top_group, bot_group)
    output = {}
    top_group.each do |root_dimension, unit_names|
      output[root_dimension] ||= {}
      output[root_dimension][:numerators] = unit_names
    end
    bot_group.each do |root_dimension, unit_names|
      output[root_dimension] ||= {}
      output[root_dimension][:denominators] = unit_names
    end
    output
  end

  def _numerator_by_dimensions
    unit.numerator.group_by { |unit_name| _get_root_dim unit_name }
  end

  def _denominator_by_dimensions
    unit.denominator.group_by { |unit_name| _get_root_dim unit_name }
  end

  def _value_from_ratio(top, bottom)
    _get_conversion_value(top) / _get_conversion_value(bottom)
  end

  def _get_conversion_value(unit_name)
    _get_dim(unit_name).to_converter_value
  end

  def _get_dim(unit_name)
    CommerceUnits.dimensional_database.find_by_unit_name! unit_name
  end

  def _get_root_dim(unit_name)
    _get_dim(unit_name).root_dimension
  end
end
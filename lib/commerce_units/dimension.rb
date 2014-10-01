# == Schema Information
#
# Table name: commerce_units_dimensions
#
#  id                :integer          not null, primary key
#  root_dimension    :string(255)      not null
#  unit_name         :string(255)      not null
#  multiply_constant :decimal(15, 5)   default(1.0), not null
#  unitary_role      :string(255)      default("tertiary"), not null
#  created_at        :datetime
#  updated_at        :datetime
#

class CommerceUnits::Dimension < ActiveRecord::Base
  class NoPrimaryUnit < StandardError; end
  KnownRoots = [:money, :mass]

  scope :primary_roles,
    -> { where "#{self.table_name}.unitary_role = ?", :primary }

  scope :by_roots,
    -> (root_name) { where "#{self.table_name}.root_dimension = ?", root_name }

  scope :primary_unit_by_roots,
    -> (root_name) { primary_roles.by_roots(root_name) }

  class << self
    def from_array_of_unit_names!(names)
      result = where unit_name: names
      unless result.count == names.count
        unfound_names = names.map(&:to_s) - result.map(&:unit_name)
        raise ActiveRecord::RecordNotFound, "I don't know the following units: #{unfound_names} out of #{names}"
      end
      result
    end

    def create_and_consider_making_primary!(param_hash)
      dimension = create! param_hash
      dimension.make_primary! if primary_unit_by_roots(dimension.root_dimension).blank?
      dimension
    end

    def find_or_create_and_consider_making_primary!(param_hash)
      where(param_hash).first || create_and_consider_making_primary!(param_hash)
    end
  end

  def to_converter_unit
    CommerceUnits::Unit.new.tap do |u|
      u.numerator = [_primary_root_unit_name]
      u.denominator = [unit_name]
    end
  end

  def to_unit
    CommerceUnits::Unit.new.tap do |u|
      u.numerator = [unit_name]
    end
  end

  def to_converter_value
    CommerceUnits::Value.new.tap do |v|
      v.number = multiply_constant
      v.unit = to_converter_unit
    end
  end

  def to_value
    CommerceUnits::Value.new.tap do |v|
      v.number = multiply_constant
      v.unit = to_unit
    end
  end

  def make_primary!
    _shift_primary! if self.class.primary_unit_by_roots(root_dimension).present?
    _make_primary!
    self
  end

  private
  def _make_primary!
    update multiply_constant: 1.0,
      unitary_role: :primary
  end
  def _shift_primary!
    self.class.by_roots(root_dimension).reject do |dim|
      dim.id == self.id
    end.each do |dim|
      dim.update multiply_constant: dim.multiply_constant / multiply_constant,
        unitary_role: :secondary
    end
  end
  def _primary_unit
    self.class.primary_unit_by_roots(root_dimension).first
  end
  def _primary_root_unit_name
    d = _primary_unit
    raise NoPrimaryUnit, "#{root_dimension} does not have a primary unit" if d.blank?
    d.unit_name
  end
end

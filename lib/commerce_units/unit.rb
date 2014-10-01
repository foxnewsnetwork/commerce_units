class CommerceUnits::Unit
  class RequireOrdInstance < StandardError; end
  class << self
    def multiply(ua, ub)
      new.tap do |u|
        u.numerator = ua.numerator + ub.numerator
        u.denominator = ua.denominator + ub.denominator
      end.simplify
    end
    def divide(ua, ub)
      multiply ua, ub.flip
    end
    def equals?(ua, ub)
      divide(ua, ub).unitless?
    end
    def parse(string)
      CommerceUnits::UnitParser.parse(string)
    end
  end

  attr_reader :numerator, :denominator
  def initialize
    @numerator = []
    @denominator = []
  end

  def *(other)
    self.class.multiply self, other
  end

  def /(other)
    self.class.divide self, other
  end

  def simplify
    CommerceUnits::Unit.new.tap do |u|
      u.numerator = _simplifier.numerator
      u.denominator = _simplifier.denominator
    end
  end

  def unitless?
    numerator.blank? and denominator.blank?
  end

  def flip
    CommerceUnits::Unit.new.tap do |u|
      u.numerator = denominator
      u.denominator = numerator
    end
  end

  def to_root_dimension
    CommerceUnits::Unit.new.tap do |u|
      u.numerator = CommerceUnits.dimensional_database.from_array_of_unit_names!(numerator).map(&:root_dimension)
      u.denominator = CommerceUnits.dimensional_database.from_array_of_unit_names!(denominator).map(&:root_dimension)
    end
  end

  def numerator=(xs)
    _assert_all_orderable! xs
    @numerator = xs
  end

  def denominator=(xs)
    _assert_all_orderable! xs
    @denominator = xs
  end

  def ==(unit)
    s = self.simplify
    u = unit.simplify
    s.numerator == u.numerator && s.denominator == u.denominator
  end

  def to_s
    '#<CommerceUnits::Unit:' + self.object_id.to_s + " @numerator=#{numerator}, @denominator=#{denominator}>"
  end

  def pretty_inspect
    n = numerator.join(" * ")
    d = denominator.join(" * ")
    n = n.blank? ? "(1)" : n
    [n,d].reject(&:blank?).join(" / ")
  end

  private
  def _assert_all_orderable!(xs)
    xs.map do |x|
      unless x.respond_to?(:<) && x.respond_to?(:>)
        raise RequireOrdInstance, "You tried to use #{x} as a unit, but I can't do it because it's not comparable"
      end
    end
  end
  def _simplifier
    @simplifier ||= CommerceUnits::Simplifier.new numerator: numerator, denominator: denominator
  end
end
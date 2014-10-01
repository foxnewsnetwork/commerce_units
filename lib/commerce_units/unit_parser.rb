class CommerceUnits::UnitParser
  class UnexpectedToken < StandardError; end
  class << self
    def parse(string)
      _tokens(string).reduce_with_lookahead(new) do |parser, token, lookahead|
        case token
        when "*"
          parser.multiply_token
        when "/"
          parser.divide_token
        when nil
          parser.eof_token
        else
          parser.units_token token
        end
      end.unit
    end

    private
    def _tokens(string)
      tokens = CommerceUnits::UnitLexer.tokenize(string)
      tokens += [nil] if tokens.count.odd?
      tokens
    end
  end
  attr_accessor :unit
  def initialize
    @mode = :multiply
    @unit = CommerceUnits::Unit.new
  end
  def multiply_token
    if :units == @mode
      @mode = :multiply
    end
    self
  end
  def divide_token
    if :units == @mode
      @mode = :divide
    end
    self
  end
  def eof_token
    case @mode
    when :multiply
      raise UnexpectedToken, "You need to multiply by a term, not just end the file"
    when :divide
      raise UnexpectedToken, "You need to divide by a term, not just end the file"
    else
      @mode = :eof
    end
    self
  end
  def units_token(token)
    case @mode
    when :multiply
      @unit *= CommerceUnits::Unit.new.tap { |u| u.numerator = [token] }
      @mode = :units
    when :divide
      @unit *= CommerceUnits::Unit.new.tap { |u| u.denominator = [token] }
      @mode = :units
    else
      raise UnexpectedToken, "You didn't tell me to either divide or multiply by your token: #{token}"
    end
    self
  end
end


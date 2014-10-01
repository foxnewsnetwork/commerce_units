class CommerceUnits::UnitLexer
  class UnexpectedCharacter < StandardError; end
  class << self
    def tokenize(string)
      string.split("").inject(new) do |lexer, character|
        case character
        when "*"
          lexer.multiply_token
        when "/"
          lexer.divide_token
        when " "
          lexer.white_space
        when /[a-zA-Z0-9]/
          lexer.character character
        else
          raise UnexpectedCharacter, character
        end
      end.tokens
    end
  end
  attr_accessor :tokens
  def initialize
    @tokens = []
    @mode = :new_character
  end
  def multiply_token
    _operator_token "*"
  end
  def divide_token
    _operator_token "/"
  end
  def white_space
    if :character == @mode
      @tokens[-1] += " "
      @mode = :space
    end
    self
  end
  def character(character)
    case @mode
    when :new_character
      @tokens << character
      @mode = :character
    when :character, :space
      @tokens[-1] += character
      @mode = :character
    else
      raise UnexpectedCharacter, "character #{character} doesn't belong here"
    end
    self
  end
  private
  def _operator_token(operator)
    case @mode
    when :character
      @tokens << operator
      @mode = :new_character
    when :space
      @tokens[-1].strip!
      @tokens << operator
      @mode = :new_character
    else
      raise UnexpectedCharacter, operator + ' should come after only units'
    end
    self
  end
end
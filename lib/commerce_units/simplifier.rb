class CommerceUnits::Simplifier
  class NotComparable < StandardError; end
  def initialize(numerator: [], denominator: [])
    @original_top = numerator.sort
    @original_bot = denominator.sort
  end

  def numerator
    @numerator ||= _reduced_numerator_from top: @original_top, bot: @original_bot
  end

  def denominator
    @denominator ||= _reduced_denominator_from top: @original_top, bot: @original_bot
  end

  private
  def _reduced_numerator_from(top: [], bot: [])
    return top if top.blank? or bot.blank?
    return _reduced_numerator_from(top: top.tail, bot: bot.tail) if top.first == bot.first
    return _reduced_numerator_from(top: top, bot: bot.tail) if top.first > bot.first
    return [top.first] + _reduced_numerator_from(top: top.tail, bot: bot) if top.first < bot.first
    raise NotComparable, "Failed to compare #{top.first} with #{bot.first}"
  end

  def _reduced_denominator_from(top: [], bot: [])
    return bot if top.blank? or bot.blank?
    return _reduced_denominator_from(top: top.tail, bot: bot.tail) if top.first == bot.first
    return [bot.first] + _reduced_denominator_from(top: top, bot: bot.tail) if bot.first < top.first
    return _reduced_denominator_from(top: top.tail, bot: bot) if bot.first > top.first
    raise NotComparable, "Failed to compare #{top.first} with #{bot.first}"
  end

end
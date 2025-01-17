# frozen_string_literal: true

##
# Holds information about one dice roll
class Roll
  attr_reader :value, :against

  ##
  # Update success and critical values
  def evaluate
    return if @against.nil?

    @success = @value <= @against
    @crit = @success ? @value <= @against / 10 : 100 - @against / 10 < @value
  end

  def initialize(value, against = nil)
    @value = value
    @against = against
    @success = nil
    @crit = nil

    evaluate
  end

  def |(other)
    Roll.new(other.to_i, @value)
  end

  alias check |

  def *(other)
    Roll.new(@value * other.to_i, @against)
  end

  def +(other)
    Roll.new(@value + other.to_i, @against)
  end

  def -(other)
    Roll.new(@value - other.to_i, @against)
  end

  def crit?
    @crit
  end

  def succ?
    @success
  end

  def fail?
    !@success
  end

  def coerce(other)
    [Roll.new(other.to_i, nil), self]
  end

  def to_s
    return @value.to_s if @against.nil?

    code = @success ? 112 : 160
    crit_msg = @crit ? "\e[38;5;160m󱈸 " : ''
    "#{crit_msg}\e[38;5;#{code}m #{@against} \e[38;5;#{code}m󰝮 #{@value}\e[0m"
  end

  def to_i
    @value
  end

  def inspect
    return @value.to_s if @against.nil?

    crit_msg = @crit ? '[CRIT] ' : ''
    outcome = @success ? 'Success' : 'Fail'
    "#{crit_msg}#{outcome}  #{@against} 󰝮 #{@value}"
  end
end

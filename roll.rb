# frozen_string_literal: true

##
# Holds information about one dice roll
class Roll
  include Comparable

  attr_reader :value, :against

  def <=>(other)
    @value <=> other.to_i
  end


  def initialize(value, against = nil)
    @value = value
    @against = against
    @success = nil
    @crit = nil

    evaluate
  end

  ##
  # Check value of this roll against another value
  # @param other [Integer, Dice, Roll] Value to check this roll against
  # @return [Roll] A new roll with other.to_i as value and @value as against
  def |(other)
    Roll.new(other.to_i, @value)
  end

  alias check |

  ##
  # Creates new Roll with self.value multiplied by other
  # @param other [Integer, Roll, Dice]
  # @return [Roll]
  def *(other)
    Roll.new(@value * other.to_i, @against)
  end

  def +(other)
    Roll.new(@value + other.to_i, @against)
  end

  def -(other)
    Roll.new(@value - other.to_i, @against)
  end

  ##
  # Return true if this roll was critical. If success or failure should be determined by succ?
  # @return [Boolean]
  def crit?
    @crit
  end

  ##
  # Returns true if this roll was a success, otherwise false
  # @return [Boolean]
  def succ?
    @success
  end

  ##
  # Returns true if this roll was a failure, otherwise true
  # @return [Boolean]
  def fail?
    !@success
  end

  ##
  # other must implement to_i to be used in coerce
  # @param other [Object.to_i]
  # @return [Array<Roll>]
  def coerce(other)
    [Roll.new(other.to_i, nil), self]
  end

  ##
  # Pretty representation of this roll containing information about success, critical status
  # as well as value and what it was measured against
  # @return [String]
  def to_s
    return @value.to_s if @against.nil?

    code = @success ? 112 : 160
    crit_msg = @crit ? "\e[38;5;160m󱈸 " : ''
    "#{crit_msg}\e[38;5;#{code}m #{@against} \e[38;5;#{code}m󰝮 #{@value}\e[0m"
  end

  ##
  # Returns the integer value of this roll
  # @return [Integer]
  def to_i
    @value
  end

  def inspect
    return @value.to_s if @against.nil?

    crit_msg = @crit ? '[CRIT] ' : ''
    outcome = @success ? 'Success' : 'Fail'
    "#{crit_msg}#{outcome}  #{@against} 󰝮 #{@value}"
  end

  private

  ##
  # Update success and critical values
  def evaluate
    return if @against.nil?

    @success = @value <= @against
    @crit = @success ? @value <= @against / 10 : 100 - @against / 10 < @value
  end
end

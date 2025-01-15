# frozen_string_literal: true

##
# Holds information about one dice roll
class Roll
  attr_reader :value, :against

  ##
  # Update success and critical values
  def get_succ
    return if @against.nil?

    @success = @value <= @against
    @crit = @success ? @value <= @against / 10 : 100 - @against / 10 < @value
  end

  def initialize(value, against = nil)
    @value = value
    @against = against
    @success = nil
    @crit = nil

    get_succ
  end

  def *(other)
    @value *= other
    get_succ
    self
  end

  def +(other)
    @value += other
    get_succ
    self
  end

  def -(other)
    @value -= other
    get_succ
    self
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
    to_s
  end
end

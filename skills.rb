# frozen_string_literal: true

require_relative 'dynamic'

##
# Base class for skill definitions
# Automatically calculates values according to HTBAH rule-set
class Skills < Dynamic
  attr_reader :sum, :attributes, :bolts

  ##
  # Recalculate values each time a new attribute is added to this skill-set
  def attribute_added
    recalculate
  end

  ##
  # When a sum is provided, all attributes are ignored and the skill-set only consists
  # of this base sum.
  # Otherwise, each attribute is added and sum, bolts and final attribute values are
  # calculated
  # @param sum [Integer]
  # @param attributes [Hash<Symbol, Integer>]
  def initialize(sum = nil, **attributes)
    if sum.nil?
      super(attributes)
      recalculate
    else
      super({})
      @sum = sum
      @max_bolts = 0
      @bolts = 0
    end
  end

  ##
  # Calculate sum of attributes, bolts and final attribute values. Changes @attributes
  # as well as @bolts
  def recalculate
    @sum = @attributes.empty? ? 0 : (@attributes.values.sum.to_f / 10.0).round
    @max_bolts = (@sum.to_f / 10.0).round
    @bolts = @max_bolts
    @attributes.transform_values! { |value| value + @sum }
  end

  ##
  # Uses one bolt, unless all have already been used. Prints the result
  def retry
    if @bolts.positive?
      @bolts -= 1
      puts " #{@bolts} sind übrig"
    else
      puts "\e[38;5;160mKeine  übrig\e[0m"
    end
  end

  ##
  # Resets bolts to maximum value in this skill-set
  def refill_bolts
    @bolts = @max_bolts
  end

  ##
  # Returns Integer sum of self.sum and other
  def +(other)
    @sum + other
  end

  def -(other)
    @sum - other
  end

  def coerce(other)
    [other, @sum]
  end

  ##
  # Returns self.sum
  def to_i
    @sum
  end

  def to_s
    @attributes.sum("󰒠 #{@sum}  #{@bolts}\n------\n") { |name, value| "    - #{name.to_s.gsub('_', ' ').capitalize}: #{value}\n" }
  end

  def inspect
    to_s
  end
end

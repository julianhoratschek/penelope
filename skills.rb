# frozen_string_literal: true

require_relative 'dynamic'

class Skills < Dynamic
  attr_reader :sum, :attributes, :bolts

  def attribute_added
    recalculate
  end

  def initialize(sum = nil, **attributes)
    if sum.nil?
      super(attributes)
      recalculate
    else
      super({})
      @sum = sum
      @bolts = 0
    end
  end

  def recalculate
    @sum = @attributes.empty? ? 0 : (@attributes.values.sum.to_f / 10.0).round
    @bolts = (@sum.to_f / 10.0).round
    @attributes.transform_values! { |value| value + @sum }
  end

  def +(other)
    @sum + other
  end

  def -(other)
    @sum - other
  end

  def coerce(other)
    [other, @sum]
  end

  def to_i
    @sum
  end

  def to_s
    "Summe: #{@sum}\n\n" + @attributes.sum('') { |key, value| "  #{value}: #{key}\n" }
  end
end

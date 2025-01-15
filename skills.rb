# frozen_string_literal: true


class Skills
  def initialize(**attributes)
    @attributes = attributes
    @sum = (@attributes.values.sum.to_f / 10.0).round
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
    @attributes.sum('') { |key, value| "  #{value}: #{key}\n" } + "  Base: #{@sum}"
  end
end

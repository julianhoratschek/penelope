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
      @max_bolts = 0
      @bolts = 0
    end
  end

  def recalculate
    @sum = @attributes.empty? ? 0 : (@attributes.values.sum.to_f / 10.0).round
    @max_bolts = (@sum.to_f / 10.0).round
    @bolts = @max_bolts
    @attributes.transform_values! { |value| value + @sum }
  end

  def retry
    if @bolts.positive?
      @bolts -= 1
      puts " #{@bolts} sind übrig"
    else
      puts "\e[38;5;160mKeine  übrig\e[0m"
    end
  end

  def refill_bolts
    @bolts = @max_bolts
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
    @attributes.sum(
      "󰒠 #{@sum}  #{@bolts}\n------\n\n"
    ) do |name, value|
      "    - #{name.to_s.gsub('_', ' ').capitalize}: #{value}\n"
    end
  end

  def inspect
    to_s
  end
end

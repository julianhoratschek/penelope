# frozen_string_literal: false

require_relative 'skills'

class Character < Dynamic
  @icons = {
    handeln: '󰓥',
    wissen: '󰧑',
    sozial: ''
  }

  class << self
    attr_reader :icons
  end

  def initialize(attributes)
    super(attributes)
    @attributes = {
      name: 'npc',
      hp: 100,
      handeln: Skills.new(0),
      wissen: Skills.new(0),
      sozial: Skills.new(0)
    }.merge(attributes)
  end

  def rename(new_name)
    tap { @attributes[:name] = new_name }
  end

  def attr_to_s(attr_name)
    attr_symbol = (Character.icons.include? attr_name) ? Character.icons[attr_name] : ' '
    result = "  #{attr_symbol} #{attr_name.to_s.capitalize}: #{@attributes[attr_name].sum}  #{@attributes[attr_name].bolts}\n  ------\n\n"
    @attributes[attr_name].attributes.each_pair do |name, value|
      result += "    - #{name}: #{value}\n"
    end
    result + "\n"
  end

  alias skills attr_to_s

  def to_s
    result = " #{@attributes[:name]}\n---------\n\n"
    result += skills(:handeln)
    result += skills(:wissen)
    result + skills(:sozial)
  end
end


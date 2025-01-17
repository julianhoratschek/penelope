# frozen_string_literal: false

require_relative 'glue'
require_relative 'skills'

class Character < Dynamic
  @icons ||= {
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
    attr_symbol = Character.icons.include?(attr_name) ? Character.icons[attr_name] : ' '
    result = "  #{attr_symbol} #{attr_name.to_s.capitalize}: #{@attributes[attr_name].sum}  #{@attributes[attr_name].bolts}\n  ------\n"

    @attributes[attr_name]
      .attributes
      .sum(result) { |name, value| "    - #{name.to_s.gsub('_', ' ').capitalize}: #{value}\n" }

    # @attributes[attr_name].attributes.each_pair do |name, value|
    #   result += "    - #{name.to_s.gsub('_', ' ').capitalize}: #{value}\n"
    # end
    # result + "\n"
  end

  def to_s
    " #{@attributes[:name]}\n---------\n#{attr_to_s(:handeln)}\n#{attr_to_s(:wissen)}\n#{attr_to_s(:sozial)}\n"
  end

  def inspect
    a, k, s = @attributes.fetch_values(:handeln, :wissen, :sozial)
    " #{@attributes[:name]}: 󰓥 #{a.sum}(#{a.bolts}) 󰧑 #{k.sum}(#{k.bolts})  #{s.sum}(#{s.bolts})\n"
  end
end


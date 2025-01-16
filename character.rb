# frozen_string_literal: false

require_relative 'skills'

class Character < Dynamic
  def initialize(attributes)
    super(attributes)
    @attributes = {
      name: 'npc',
      hp: 100,
      action: Skills.new(5),
      knowledge: Skills.new(5),
      social: Skills.new(5)
    }.merge(attributes)
  end

  def rename(new_name)
    tap { @attributes[:name] = new_name }
  end
end


# frozen_string_literal: true

require_relative 'character'

##
# Base Class to quickly create throw-away NPC for fights
class Npc < Character
  include Glue

  @npc_count ||= {}

  class << self
    attr_reader :npc_count
  end

  ##
  # Keep track of how many instances of this NPC-prefab have been created, change name accordingly
  def count
    name = @attributes[:name]
    if Npc.npc_count.include? name
      Npc.npc_count[name] += 1
      @attributes[:name] = "#{name} #{Npc.npc_count[name]}"
    else
      Npc.npc_count[name] = 0
      @@npcs << self
    end
  end

  def initialize(**attributes)
    super(attributes)
    count
  end

  def rename(new_name)
    super(new_name)
    tap { count }
  end

  def *(other)
    Array.new(other) { Npc.new(**@attributes) }
  end
end


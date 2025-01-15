# frozen_string_literal: true

require_relative 'character'

##
# Base Class to quickly create throw-away NPC for fights
class Npc < Character
  @npc_count ||= {}

  ##
  # Keep track of how many instances of this NPC-prefab have been created, change name accordingly
  def self.count(attributes)
    name = attributes[:name]
    if @npc_count.include? name
      @npc_count[name] += 1
      attributes[:name] = "#{name} #{@npc_count[name]}"
    else
      @npc_count[name] = 0
    end
  end

  def initialize(attributes)
    super(attributes)
    Npc.count @attributes
  end

  def rename(new_name)
    super(new_name).tap { Npc.count @attributes }
  end

  def *(other)
    Array.new(other) { Npc.new(@attributes) }
  end
end


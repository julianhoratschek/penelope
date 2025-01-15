# frozen_string_literal: true


##
# Base Class to quickly create throw-away NPC for fights
class Npc
  @npc_count ||= {}

  ##
  # Add or access any attributes provided by the user
  def method_missing(name, *args)
    return @attributes[name.chop.to_sym] = args[0] if name[-1] == '='
    return @attributes[name] if @attributes.include? name

    super
  end

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
    Npc.count @attributes = { name: "npc", hp: 100, action: 5, knowledge: 5, social: 5 }.merge(attributes)

    super()
  end

  def rename(new_name)
    Npc.count @attributes[:name] = new_name
    self
  end

  def *(other)
    Array.new(other) { Npc.new(@attributes) }
  end
end


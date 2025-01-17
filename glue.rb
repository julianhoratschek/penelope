# frozen_string_literal: false

module Glue
  @@players = []
  @@npcs = []

  def self.players
    @@players
  end

  def self.players=(other)
    @@players = other
  end

  def self.npcs
    @@npcs
  end

  def self.npcs=(other)
    @@npcs = other
  end

  def self.find(name)
    idx = @@players.index { |player| player.name.downcase == name.downcase }
    return @@players[idx] unless idx.nil?

    idx = @@npcs.index { |npc| npc.name.downcase == name.downcase }
    @@npcs.fetch(idx, nil)
  end
end

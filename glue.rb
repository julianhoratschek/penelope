# frozen_string_literal: false

module Glue
  @@players = []
  @@npcs = []

  def self.save_all(file_name)
    File.open(file_name, 'w') do |fl|
      fl.write(Marshal.dump({players: @@players, npcs: @@npcs}))
    end
  end

  def self.load(file_name)
    loaded = Marshal.load(File.new(file_name))
    @@players = loaded[:players]
    @@npcs = loaded[:npcs]
    loaded
  end
end

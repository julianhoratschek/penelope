# frozen_string_literal: false


class Character
  ##
  # Add or access any attributes provided by the user
  def method_missing(name, *args)
    return @attributes[name.chop.to_sym] = args[0] if name[-1] == '='
    return @attributes[name] if @attributes.include? name

    super
  end

  def initialize(attributes)
    @attributes = { name: "npc", hp: 100, action: 5, knowledge: 5, social: 5 }.merge(attributes)
  end

  def rename(new_name)
    tap { @attributes[:name] = new_name }
  end
end


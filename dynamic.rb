# frozen_string_literal: false

class Dynamic
  ##
  # Add or access any attributes provided by the user
  def method_missing(name, *args)
    return @attributes[name.chop.to_sym] = args[0] if name[-1] == '='
    return @attributes[name] if @attributes.include? name

    super
  end

  def initialize(attributes)
    @attributes = attributes
  end
end

# frozen_string_literal: false

class Dynamic
  ##
  # Add or access any attributes provided by the user
  def method_missing(name, *args)
    if name[-1] == '='
      @attributes[name.to_s.chop.to_sym] = args[0]
      attribute_added
      return
    end
    return @attributes[name] if @attributes.include? name

    super
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def remove(attr_name)
    @attributes.delete(attr_name)
    attribute_removed
  end

  def attribute_added; end
  def attribute_removed; end

  protected :attribute_added, :attribute_removed
end

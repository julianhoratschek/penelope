# frozen_string_literal: false

##
# Open-Struct like base class
# Adds all newly assigned properties onto the class and can access dynamically added
# properties
class Dynamic
  ##
  # Add or access any attributes provided by the user
  def method_missing(name, *args)
    if name[-1] == '='
      @attributes[name.to_s.chop.to_sym] = args[0]
      return attribute_added
    end

    return @attributes[name] if @attributes.include? name

    super
  end

  ##
  # Initialize with properties defined by attributes
  # @param attributes [Hash<Symbol, Object>]
  def initialize(attributes)
    @attributes = attributes
  end

  ##
  # Delete attr_name as property from this object
  # @param attr_name [Symbol]
  def remove(attr_name)
    @attributes.delete(attr_name)
    attribute_removed
  end

  protected

  def attribute_added; end
  def attribute_removed; end
end

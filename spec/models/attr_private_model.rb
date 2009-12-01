class AttrPrivateModel < ActiveRecord::Base
  attr_private :private_attribute

  def set_private_attribute(attribute)
    self.private_attribute = attribute
  end

  def get_private_attribute
    self.private_attribute
  end

  def get_attributes
    self.attributes
  end

  def get_read_attribute(attr)
    self.read_attribute(attr)
  end

  def get_read_attribute_before_type_cast(attr)
    self.read_attribute_before_type_cast(attr)
  end

  def get_attributes_before_type_cast
    self.attributes_before_type_cast
  end
end


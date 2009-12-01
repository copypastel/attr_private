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
end


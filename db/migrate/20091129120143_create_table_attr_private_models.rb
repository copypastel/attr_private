class CreateTableAttrPrivateModels < ActiveRecord::Migration
  def self.up
   create_table :attr_private_models do |t|
    t.string :private_attribute 
    t.string :public_attr
   end
  end

  def self.down
    drop_table :attr_private_models
  end
end

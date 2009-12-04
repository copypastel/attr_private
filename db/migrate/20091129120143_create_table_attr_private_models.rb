class CreateTableAttrPrivateModels < ActiveRecord::Migration
  def self.up
   create_table :attr_private_models do |t|
    t.string :private_attribute 
    t.string :public_attribute
   end

   create_table :attr_public_models do |t|
     t.string :public_attribute
   end
  end

  def self.down
    drop_table :attr_private_models
    drop_table :attr_public_models
  end
end

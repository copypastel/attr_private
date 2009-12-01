require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "ActiveRecord::Base" do
  before(:each) do
    class Model < ActiveRecord::Base
    end
  end

  after(:each) do
    Object.send(:remove_const,:Model)
  end

  describe "#attr_private" do

    it "should respond to #attr_private" do
      Model.should respond_to(:attr_private)
    end

    it "should take n attributes to be made private" do
      lambda { Model.attr_private(:first_attr) }.should_not raise_error
      lambda { Model.attr_private(:first_attr,:second_attr) }.should_not raise_error
      lambda { Model.attr_private(:first_attr,:second_attr,:n_attr) }.should_not raise_error
    end

    it "should return a set of other stringified private_attributes" do
      (set = Model.attr_private(:first_attr)).class.should eql(Set)
      set.should include('first_attr')
      (set = Model.attr_private(:second_attr)).class.should eql(Set)
      set.should include('first_attr')
      set.should include('second_attr')
      set.should_not include(:first_attr)
    end 

    it "should use the rails method write_inheritable_attribute with :attr_private to store attributes" do
      Model.attr_private(:first_attr).should include('first_attr')
      Model.send(:read_inheritable_attribute,:attr_private).should include('first_attr')
      Model.attr_private(:second_attr).should include('second_attr')
      Model.send(:read_inheritable_attribute,:attr_private).should include('second_attr')
      Model.send(:read_inheritable_attribute,:attr_private).should include('second_attr')
      set = Model.attr_private(:third_attr,:fourth_attr)
      set.should include('first_attr')
      set.should include('second_attr')
      set.should include('third_attr')
      set.should include('fourth_attr')
    end
  end

  describe "#private_attributes" do
    it "should respond to #private_attributes" do
      Model.should respond_to(:private_attributes)
    end

    it "should return a Set containing all private attributes added" do
      Model.attr_private(:first_attr,:second_attr)
      Model.private_attributes.class.should eql(Set)
      Model.private_attributes.should include('first_attr')
      Model.private_attributes.should include('second_attr')
    end
  end
end

describe "ActiveRecord::AttributeMethods" do
  before(:all) do
   autoload :AttrPrivateModel, File.dirname(__FILE__) + '/models/attr_private_model' 
  end
  
  before(:each) do
    @model = AttrPrivateModel.new
  end

  after(:each) do
    AttrPrivateModel.all.each { |a| a.destroy }
  end

  describe "Read" do
    it "should raise a NoMethodError private method called when trying to access private attribute" do
      lambda { @model.private_attribute }.should raise_error(NoMethodError)
    end

    it "should not affect access of public methods" do
      lambda { @model.public_attribute }.should_not raise_error(NoMethodError)
    end

    it "should not be present in the #attributes call" do
      @model.attributes.should_not include('private_attribute')
      @model.attributes.should include('public_attribute')
    end

    it "should be present when using a class method to access #attributes" do
      @model.get_attributes.should include('private_attribute')
      @model.get_attributes.should include('private_attribute')
    end

    it "should return nil when trying to use #read_attribute with a private attribute" do
      attribute = "hello"
      @model.set_private_attribute(attribute)
      @model.public_attribute = attribute
      @model.read_attribute(:private_attribute).should be(nil)
      @model.read_attribute(:public_attribute).should eql(attribute)
    end 
      

    it "should return the value when trying to use #read_attribute from within the model" do
      attribute = "hello"
      @model.set_private_attribute(attribute)
      @model.get_read_attribute(:private_attribute).should eql(attribute)
    end
      
  end

  describe "Write" do
    it "should raise a NoMethodError private method called when trying to set private attribute" do
      lambda { @model.private_attribute = "attribute" }.should raise_error(NoMethodError)
    end

    it "should not affect writing of public methods" do
      attribute = "hello"
      lambda { @model.public_attribute = attribute }.should_not raise_error(NoMethodError)
      @model.public_attribute = attribute
      @model.public_attribute.should eql(attribute)
    end

    it "should allow writing within the class." do
      attribute = "hello"
      @model.set_private_attribute attribute
      @model.get_private_attribute.should eql(attribute)
    end
  end

  describe "Database" do
    it "should not interfear with normal database operations" do
      attribute = "hello"
      @model.public_attribute = attribute
      @model.save.should be(true)
      model = AttrPrivateModel.find @model.id
      @model.public_attribute.should eql(model.public_attribute) 
    end

    it "should save and retrieve a private attribute" do
      attribute = "hello"
      @model.set_private_attribute attribute
      @model.save.should be(true)
      model = AttrPrivateModel.find @model.id
      @model.get_private_attribute.should eql(model.get_private_attribute)
    end

    it "should not be affected by mass updates" do
      attribute = "hello"
      @model.get_private_attribute.should be(nil)
      @model.update_attributes!(:private_attribute => attribute, :public_attribute => attribute)
      @model.get_private_attribute.should be(nil)
      @model.public_attribute.should eql(attribute)
    end
  end
end

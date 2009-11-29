require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "ActiveRecord::Base" do
  describe "#attr_private" do
    before(:each) do
      class Model < ActiveRecord::Base
      end
    end

    after(:each) do
      Object.send(:remove_const,:Model)
    end

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
    end
  end
end

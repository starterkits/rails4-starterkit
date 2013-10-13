require 'spec_helper'

class DummyController < DeviseController
  include DeviseReturnToConcern
  attr_accessor :params, :session, :resource_name
  def initialize
    @params = {}.with_indifferent_access
    @session = {}.with_indifferent_access
    @resource_name = 'user'
  end
  def is_navigational_format?; true; end
end

describe DeviseReturnToConcern do
  let(:controller) { DummyController.new }

  describe "store_location!" do
    it "sets session when return_to param is present" do
      path = '/some/test/path'
      controller.params = { return_to: path }
      controller.store_location!
      controller.session[:"#{controller.resource_name}_return_to"].should == path
      controller.session[:"#{controller.resource_name}_return_to_timestamp"].should >= Time.now.utc.to_i
      controller.stored_location_for(controller.resource_name).should == path
    end
    it "does not change session when return_to is missing" do
      controller.store_location!
      controller.session[:"#{controller.resource_name}_return_to"].should be_nil
      controller.session[:"#{controller.resource_name}_return_to_timestamp"].should be_nil
      controller.stored_location_for(controller.resource_name).should be_nil
    end
  end

  describe "after_sign_in_path_for" do
    it "returns stored location" do
      path = '/some/test/path'
      controller.params = { return_to: path }
      controller.store_location!
      controller.after_sign_in_path_for(controller.resource_name).should == path
    end
    it "does not return stored path if expired" do
      path = '/some/test/path'
      user_root_path = '/user/root'
      controller.stub(user_root_path: user_root_path)
      controller.params = { return_to: path }
      controller.store_location!
      controller.session[:"#{controller.resource_name}_return_to_timestamp"] = \
        Time.now.utc.to_i - DummyController::RETURN_TO_TIMEOUT - 10
      controller.after_sign_in_path_for(controller.resource_name).should_not == path
      controller.after_sign_in_path_for(controller.resource_name).should == user_root_path
    end
  end
end

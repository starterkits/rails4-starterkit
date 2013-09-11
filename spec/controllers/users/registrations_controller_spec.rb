require 'spec_helper'

describe Users::RegistrationsController do
  describe "#create" do
    it "should redirect to after sign up url" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: {first_name: 'Test', email: 'test@example.com', password: 'testpass'}
      URI(response.redirect_url).path.should == after_sign_up_path(controller.resource.id)
    end
  end
end

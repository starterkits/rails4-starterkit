require 'spec_helper'

describe Users::RegistrationsController do
  describe "#create" do
    it "should redirect to after sign up url" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: {username: 'testuser', email: 'test@connect.me', password: 'testpass'}
      URI(response.redirect_url).path.should == after_sign_up_path(controller.resource.id)
    end
  end
end

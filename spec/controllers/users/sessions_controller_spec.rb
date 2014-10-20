require 'rails_helper'

describe Users::SessionsController, :type => :controller do

  let(:user) { FactoryGirl.create(:user, password: 'testpass') }

  describe "#create" do
    it "redirects to after login url" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: {email: user.email, password: 'testpass'}
      expect(response).to redirect_to(user_root_path)
    end
  end

  describe "#destroy" do
    include Warden::Test::Helpers
    Warden.test_mode!

    before :each do
      Warden.test_reset!
    end
    it "resets session when user is logged in" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      login_as user, :scope => :user
      sess_key = '_dummy_sess_key1'
      sess_val = 'someval12345'
      session[sess_key] = sess_val
      post :destroy
      expect(session[sess_key]).to_not eq(sess_val)
    end
    it "resets session when user is not logged in" do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sess_key = '_dummy_sess_key2'
      sess_val = 'someotherval9999'
      session[sess_key] = sess_val
      post :destroy
      expect(session[sess_key]).to_not eq(sess_val)
    end
  end
end

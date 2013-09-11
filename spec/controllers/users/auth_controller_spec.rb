require 'spec_helper'
describe Users::AuthController do
  render_views

  def return_to_session_key
    scope = Devise::Mapping.find_scope!(User)
    "#{scope}_return_to"
  end
  def has_redirect_js?(path)
    # look for home path in JS code in page
    response.body.should have_content("path = \"#{path}\"")
  end

  describe "#after_sign_up" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end
    it "should redirect to path" do
      path = '/some/unique/path/to/match/in/page/abc/123'
      get :after_sign_up, path: path
      response.should be_success
      response.body.should have_css('body.after_sign_up')
      has_redirect_js?(path)
    end
    it "should redirect to user home" do
      get :after_sign_up
      has_redirect_js?(user_home_path)
    end
  end

  describe "#after_login" do
    let(:user) { FactoryGirl.create(:user) }

    context "check for password" do
      before :each do
        sign_in user
      end
      it "should redirect to create password form if no password" do
        user.update_attribute(:encrypted_password, '')
        sign_in(user) # must sign in after changing pass for some reason
        get :after_login
        response.should redirect_to(add_password_user_path(user))
      end
      it "should not redirect to create password form if password is set" do
        get :after_login
        response.should_not redirect_to(add_password_user_path(user))
      end
    end

    context "check for stored location" do
      before(:each) do
        sign_in(user)
      end
      it "should redirect to stored location if present" do
        session[return_to_session_key] = path = '/abc/123'
        get :after_login
        has_redirect_js?(path)
      end
      it "should redirect to user home if no stored location" do
        session[return_to_session_key] = nil
        get :after_login
        has_redirect_js?(user_home_path)
      end
    end
  end
end

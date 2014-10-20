require 'spec_helper'

# Use non-overridden url helpers for testing
def urls
  Rails.application.routes.url_helpers
end

class DummyClass
  include Rails.application.routes.url_helpers
  include DeviseRoutesHelper
end

describe DeviseRoutesHelper, :type => :helper do
  before(:each) do
    @dummy = DummyClass.new
    @dummy.stub(request: @request)
  end

  # The page_path is the page the user is currently on.
  # When the user is on an OAuth or Devise page, the login and sign up
  # links should not include a return_to path.
  shared_examples "a non-return to page" do |page_path|
    let(:login) { urls.new_user_session_path }
    let(:signup) { urls.new_user_registration_path }
    before(:each) { @request.stub(fullpath: page_path) }

    it "does not include return_to param for login" do
      expect(@dummy.new_user_session_path).to eq(login)
    end
    it "does not include return_to param for sign up" do
      expect(@dummy.new_user_registration_path).to eq(signup)
    end
  end

  shared_examples "a return to page" do |page_path|
    let(:login) { urls.new_user_session_path(return_to: page_path) }
    let(:signup) { urls.new_user_registration_path(return_to: page_path) }
    before(:each) { @request.stub(fullpath: page_path) }

    it "includes return_to param" do
      expect(@dummy.new_user_session_path).to eq(login)
    end
    it "includes return_to param" do
      expect(@dummy.new_user_registration_path).to eq(signup)
    end
  end

  # RegistrationController#after_auth
  describe "user_root" do
    it_behaves_like "a non-return to page", urls.user_root_path
  end
  describe "new_user_session_path" do
    it_behaves_like "a non-return to page", urls.new_user_session_path
  end
  describe "new_user_registration_path" do
    it_behaves_like "a non-return to page", urls.new_user_registration_path
  end
  describe "root_path" do
    it_behaves_like "a non-return to page", urls.root_path
  end
  describe "random page" do
    it_behaves_like "a return to page", '/some/random/page'
  end
  describe "random page with query" do
    it_behaves_like "a return to page", '/some/random/page?k=v&a=b'
  end

  describe "#valid_after_sign_in_path?" do
    it "prevents open redirects to other domains" do
      expect(@dummy.valid_after_sign_in_path?('http://someotherdomain.com/home')).to be_falsey
    end
    it "allows redirects to canonical host" do
      expect(ENV['CANONICAL_HOST']).to be_present
      path = "http://#{ENV['CANONICAL_HOST']}/some/path"
      expect(@dummy.valid_after_sign_in_path?(path)).to be_truthy
    end
  end
end

require 'spec_helper'

describe OmniauthConcern do
  include OmniauthHelpers

  before :all do
    @data = user_data
    load_omniauth_mock(@data)
  end
  before :each do
    @check_website = true
  end

  shared_examples_for "normalized oauth" do
    it "should have expected data" do
      oauth_data = @omniauth_mocks[@provider]
      norm_data, auth_attrs = Authentication.normalize_oauth(oauth_data)
      @keys_to_test.each {|key|
        norm_data[key].should == @data[key]
      }
      norm_data[:profile_url].should_not be_nil
      norm_data[:urls].should include(['Website', @data[:website]]) if @check_website
    end
  end

  context "Facebook" do
    before do
      @provider = 'facebook'
      @keys_to_test = [:uid, :verified, :username, :email, :nickname, :name, :first_name, :last_name, :location, :image_url, :bio, :nickname]
    end
    it_should_behave_like "normalized oauth"
  end

  context "Twitter" do
    before do
      @provider = 'twitter'
      @keys_to_test = [:uid, :username, :name, :location, :image_url, :bio, :nickname]
    end
    it_should_behave_like "normalized oauth"
  end

  context "LinkedIn" do
    before do
      @provider = 'linkedin'
      @check_website = false
      @keys_to_test = [:uid, :name, :first_name, :last_name, :image_url, :bio]
    end
    it_should_behave_like "normalized oauth"
  end
end

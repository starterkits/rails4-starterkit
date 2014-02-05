require 'spec_helper'

describe Concerns::OmniauthConcern do
  include OmniauthHelpers

  let(:auth) { FactoryGirl.build(:authentication) }

  before :all do
    @data = user_data
    load_omniauth_mock(@data)
  end
  before :each do
    @check_website = true
  end

  shared_examples "normalized oauth" do
    it "has expected data" do
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

  describe "#oauth_data=" do
    it "normalizes data" do
      auth.oauth_data = @omniauth_mocks['facebook']
      auth.oauth_data[:email].should == @data.email
    end
  end

  describe "#oauth_data_cache" do
    it "saves when authentication saves" do
      auth.oauth_data_cache.data_json.should be_blank
      auth.oauth_data = @omniauth_mocks['facebook']
      auth.oauth_data_cache.data_json.should be_present
      auth.save
      auth.oauth_data_cache.reload.should be_persisted
      JSON.parse(auth.oauth_data_cache.data_json)['provider'].should == 'facebook'
      auth.oauth_data_cache.authentication_id.should == auth.id
    end
    it "saves when oauth_data updates" do
      auth.save! if auth.new_record?
      auth.oauth_data_cache.should be_instance_of(OauthDataCache)
      auth.oauth_data_cache.should be_new_record
      auth.oauth_data = @omniauth_mocks['facebook']
      auth.oauth_data_cache.should be_persisted
    end
  end
end

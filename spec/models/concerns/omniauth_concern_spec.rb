require 'spec_helper'

describe Concerns::OmniauthConcern do
  include OmniauthHelpers

  let(:auth) { FactoryGirl.build(:authentication) }
  let(:oc) { auth.oauth_cache }

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

  describe "#update_from_omniauth" do
    it "updates oauth_cache" do
      auth.update_from_omniauth @omniauth_mocks['facebook']
      auth.oauth_cache.data
    end
  end

  describe "#oauth_data=" do
    it "normalizes data" do
      auth.oauth_data = @omniauth_mocks['facebook']
      auth.oauth_data[:email].should == @data.email
    end
  end

  def oauth_cache
    @oauth_cache ||= (super or build_oauth_cache)
  end

  describe "#oauth_cache" do
    it "builds new instance on demand" do
      auth.oauth_cache.should be_instance_of(OauthCache)
    end
    it "loads existing instance on demand" do
      auth.id = 99
      auth.save
      oauth = OauthCache.create(data_json: '{}', authentication_id: 99)
      auth.oauth_cache.should == oauth
    end
    it "saves when authentication saves" do
      oc.data_json.should be_blank
      auth.oauth_data = @omniauth_mocks['facebook']
      oc.data_json.should be_present
      auth.save!
      oc.reload.should be_persisted
      oc.data['provider'].should == 'facebook'
      oc.id.should == auth.id
      oc.authentication_id.should == auth.id
    end
    it "saves when oauth_data updates" do
      auth.save!
      oc.should be_new_record
      auth.oauth_data = @omniauth_mocks['facebook']
      oc.should be_persisted
      oc.data_json.should be_present
      oc.updated_at.should be_present
    end
    it "update data_json when data is set" do
      oc.data_json.should be_blank
      data = Authentication.normalize_oauth(@omniauth_mocks['facebook'])
      oc.data = data
      JSON.parse(oc.data_json).should_not == 'null'
      oc.data.should == data
    end
  end
end

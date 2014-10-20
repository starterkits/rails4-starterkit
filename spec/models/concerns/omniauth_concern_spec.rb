require 'spec_helper'

describe Concerns::OmniauthConcern, :type => :model do
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
        expect(norm_data[key]).to eq(@data[key])
      }
      expect(norm_data[:profile_url]).not_to be_nil
      expect(norm_data[:urls]).to include(['Website', @data[:website]]) if @check_website
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
      expect(auth.oauth_data[:email]).to eq(@data.email)
    end
  end

  def oauth_cache
    @oauth_cache ||= (super or build_oauth_cache)
  end

  describe "#oauth_cache" do
    it "builds new instance on demand" do
      expect(auth.oauth_cache).to be_instance_of(OauthCache)
    end
    it "loads existing instance on demand" do
      auth.id = 99
      auth.save
      oauth = OauthCache.create(data_json: '{}', authentication_id: 99)
      expect(auth.oauth_cache).to eq(oauth)
    end
    it "saves when authentication saves" do
      expect(oc.data_json).to be_blank
      auth.oauth_data = @omniauth_mocks['facebook']
      expect(oc.data_json).to be_present
      auth.save!
      expect(oc.reload).to be_persisted
      expect(oc.data['provider']).to eq('facebook')
      expect(oc.id).to eq(auth.id)
      expect(oc.authentication_id).to eq(auth.id)
    end
    it "saves when oauth_data updates" do
      auth.save!
      expect(oc).to be_new_record
      auth.oauth_data = @omniauth_mocks['facebook']
      expect(oc).to be_persisted
      expect(oc.data_json).to be_present
      expect(oc.updated_at).to be_present
    end
    it "update data_json when data is set" do
      expect(oc.data_json).to be_blank
      data = Authentication.normalize_oauth(@omniauth_mocks['facebook'])
      oc.data = data
      expect(JSON.parse(oc.data_json)).not_to eq('null')
      expect(oc.data).to eq(data)
    end
  end
end

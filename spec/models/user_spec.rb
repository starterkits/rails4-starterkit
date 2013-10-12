require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:authentication) { FactoryGirl.build(:authentication) }

  describe "#valid?" do
    it "should require password or authentication" do
      user.password = nil
      user.should_not be_valid
      user.password = 'testpass'
      user.should be_valid
      user.password = nil
      user.authentications << authentication
      user.should be_valid
    end
    it "should require email" do
      user.email = nil
      user.should_not be_valid
      user.email = 'test@example.com'
      user.should be_valid
    end
  end

  describe "has_authentication?" do
    it "should return true when new record and even with invalid authentication" do
      u = User.new
      authentication.provider = nil
      u.authentications << authentication
      u.has_authentication?.should be_true
    end
    it "should return false if persisted and with invalid authentication" do
      u = stub_model User, persisted?: true
      u.persisted?.should be_true
      authentication.provider = nil
      u.authentications << authentication
      u.has_authentication?.should be_false
    end
    it "should return true if persisted and with at least one valid authentication" do
      u = stub_model User, persisted?: true
      u.persisted?.should be_true
      authentication.provider = nil
      u.authentications << [authentication, FactoryGirl.build(:authentication)]
      u.has_authentication?.should be_true
    end
  end

  describe "#authentications" do
    it "should have many dependent authentications" do
      user.should have_many(:authentications).dependent(:destroy)
    end
  end

  describe "#reverse_merge_attributes_from_auth" do
    it "should merge email" do
      user.email = nil
      email = 'auth@domain.com'
      authentication.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(authentication)
      user.email.should == email
    end
    it "should not merge email" do
      email = 'somerandom@email.com'
      authentication.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(authentication)
      user.email.should_not == email
    end
  end
end

require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:auth) { FactoryGirl.build(:authentication) }

  describe "#create" do
    it "should require password or authentication" do
      user.password = nil
      user.should_not be_valid
      user.password = 'testpass'
      user.should be_valid
      user.password = nil
      user.authentications << auth
      user.should be_valid
    end
    it "should require email" do
      user.email = nil
      user.should_not be_valid
      user.email = 'test@example.com'
      user.should be_valid
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
      auth.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(auth)
      user.email.should == email
    end
    it "should not merge email" do
      email = 'somerandom@email.com'
      auth.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(auth)
      user.email.should_not == email
    end
  end
end

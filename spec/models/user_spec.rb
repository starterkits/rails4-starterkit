require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:authentication) { FactoryGirl.build(:authentication) }

  describe "#valid?" do
    it "requires password or authentication" do
      user.password = nil
      user.should_not be_valid
      user.password = 'testpass'
      user.should be_valid
      user.password = nil
      user.authentications << authentication
      user.should be_valid
    end
    it "requires email" do
      user.email = nil
      user.should_not be_valid
      user.email = 'test@example.com'
      user.should be_valid
    end
  end

  describe "password_required?" do
    context "with no password" do
      it "is false when new record even with invalid authentication" do
        u = User.new
        authentication.provider = nil
        u.authentications << authentication
        u.should_not be_password_required
      end
      it "is true if persisted with invalid authentication" do
        u = stub_model User, persisted?: true
        u.should be_persisted
        authentication.provider = nil
        u.authentications << authentication
        u.should be_password_required
      end
      it "is false if persisted and with at least one valid authentication" do
        u = stub_model User, persisted?: true
        u.should be_persisted
        authentication.provider = nil
        u.authentications << [authentication, FactoryGirl.build(:authentication)]
        u.should_not be_password_required
      end
    end
    context "with password" do
      it "requires password when password is set" do
        user.authentications << authentication
        user.password = 'abc'
        user.password_confirmation = nil
        user.should be_password_required
      end
      it "requires password when confirmation is set" do
        user.authentications << authentication
        user.password = nil
        user.password_confirmation = 'abc'
        user.should be_password_required
      end
    end
  end

  describe "#authentications" do
    it "has many dependent authentications" do
      user.should have_many(:authentications).dependent(:destroy)
    end
  end

  describe "#reverse_merge_attributes_from_auth" do
    it "merges email" do
      user.email = nil
      email = 'auth@domain.com'
      authentication.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(authentication)
      user.email.should == email
    end
    it "does not merge email" do
      email = 'somerandom@email.com'
      authentication.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(authentication)
      user.email.should_not == email
    end
  end
end

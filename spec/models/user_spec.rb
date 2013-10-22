require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:stubbed_user) { stub_model User, persisted?: true }
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

  describe "stubbed_user" do
    it "is persisted" do
      stubbed_user.should be_persisted
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
      it "is false when authentications are invalid if database has password" do
        u = stubbed_user
        u.encrypted_password = '123123'
        u.password = u.password_confirmation = nil
        authentication.provider = nil
        u.authentications << authentication
        u.should_not be_password_required
      end
      it "is false when persisted and with at least one valid authentication" do
        u = stubbed_user
        authentication.provider = nil
        u.authentications << [authentication, FactoryGirl.build(:authentication)]
        u.should_not be_password_required
      end
      it "is false when persisted and not changing password" do
        u = stubbed_user
        u.password = u.password_confirmation = nil
        u.should_not be_password_required
      end
      it "is true when new record and no authentications" do
        user.authentications.should be_empty
        user.should_not be_persisted
        user.should be_new_record
        user.should be_password_required
      end
      it "is true when persisted with no password and invalid authentication" do
        u = user
        u.stub('persisted?' => true)
        u.password = u.password_confirmation = nil
        u.encrypted_password = ''
        u.authentications << authentication
        u.should be_valid
        u.should be_persisted
        u.should_not be_password_required
        authentication.provider = nil
        u.should be_password_required
      end
    end
    context "with password" do
      it "is true when password is set" do
        user.password = 'abc'
        user.password_confirmation = nil
        user.should be_password_required
      end
      it "is true when password_confirmation is set" do
        user.password = nil
        user.password_confirmation = '123'
        user.should be_password_required
      end
      it "is true when password and confirmation are set to valid password" do
        pass = 'testtest'
        user.password = pass
        user.password_confirmation = pass
        user.should be_valid
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

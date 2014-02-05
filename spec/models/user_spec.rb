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
    context "with authentication" do
      context "and new record" do
        let(:user) {
          user = FactoryGirl.build(:user)
          user.encrypted_password = user.password = user.password_confirmation = nil
          user.authentications << authentication
          user
        }
        it "is always false when new record" do
          user.should be_new_record
          user.should_not be_persisted
          user.should_not be_password_required
          # Invalid provider
          user.authentications.first.provider = nil
          user.should_not be_password_required
          # Invalid + valid provider
          user.authentications << FactoryGirl.build(:authentication)
          user.should_not be_password_required
          # Not updating password
          user.password = user.password_confirmation = nil
          user.should_not be_password_required
          # Updating password
          user.password = user.password_confirmation = 'abcabcabc'
          user.should_not be_password_required
        end
      end
      context "and persisted" do
        let(:user) {
          user = stub_model User, persisted?: true
          user.authentications << authentication
          user
        }
        it "is persisted" do
          user.should be_persisted
        end
        it "is false when has at least one valid authentication" do
          user.encrypted_password = nil
          authentication.provider = nil
          user.authentications << [authentication, FactoryGirl.build(:authentication)]
          user.should_not be_password_required
        end
        it "is false when has saved password" do
          user.encrypted_password = '123123'
          user.should_not be_password_required
          user.authentications.first.provider = nil
          user.should_not be_password_required
        end
        it "is true when no saved password and invalid authentication" do
          user.encrypted_password = ''
          user.should_not be_password_required
          user.authentications.first.provider = nil
          user.should be_password_required
        end
        it "is true when password is present" do
          user.should_not be_password_required
          user.password = 'abcabc'
          user.should be_password_required
          user.password = nil
          user.password_confirmation = 'abcabc'
          user.should be_password_required
        end
      end
    end
    context "without authentication" do
      context "and new record" do
        let(:user) {
          user = FactoryGirl.build(:user)
          user.encrypted_password = user.password = user.password_confirmation = nil
          user
        }
        it "is always true when new record" do
          user.should be_new_record
          user.should_not be_persisted
          user.should be_password_required
          user.password = user.password_confirmation = nil
          user.should be_password_required
          user.password = user.password_confirmation = ''
          user.should be_password_required
          user.password = '123123123'
          user.password_confirmation = nil
          user.should be_password_required
          user.password = nil
          user.password_confirmation = 'abcabcabc'
          user.should be_password_required
        end
      end
      context "and persisted" do
        let(:user) {
          user = stub_model User, persisted?: true
          user.encrypted_password = '123123123'
          user
        }
        it "is true when password is present" do
          user.password = 'abc'
          user.password_confirmation = nil
          user.should be_password_required
          user.password = nil
          user.password_confirmation = '123'
          user.should be_password_required
        end
        it "is true when saved password is not present" do
          user.encrypted_password = ''
          user.should be_password_required
        end
        it "is false when password is not present" do
          user.should_not be_password_required
        end
      end
    end
  end

  describe "#authentications" do
    it "has many dependent authentications" do
      user.should have_many(:authentications).dependent(:destroy)
    end
    describe "#grouped_with_oauth" do
      it "groups by provider and includes oauth_data_cache" do
        user.save
        FactoryGirl.create(:authentication, user: user, provider: 'facebook')
        FactoryGirl.create(:authentication, user: user, provider: 'twitter')
        FactoryGirl.create(:authentication, user: user, provider: 'linkedin')
        FactoryGirl.create(:authentication, user: user, provider: 'facebook')
        FactoryGirl.create(:authentication, user: user, provider: 'twitter')
        auths = user.authentications.grouped_with_oauth
        auths.keys.length.should == 3
        auths['facebook'].length.should == 2
        auths['twitter'].length.should == 2
        auths['linkedin'].length.should == 1
      end
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

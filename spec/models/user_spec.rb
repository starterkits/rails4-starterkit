require 'rails_helper'

describe User, :type => :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:authentication) { FactoryGirl.build(:authentication) }

  describe "#create" do
    it "enqueues welcome email" do
      expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
      user.save
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
    end
  end

  describe "#valid?" do
    it "requires password or authentication" do
      user.password = nil
      expect(user).not_to be_valid
      user.password = 'testpass'
      expect(user).to be_valid
      user.password = nil
      user.authentications << authentication
      expect(user).to be_valid
    end
    it "requires email" do
      user.email = nil
      expect(user).not_to be_valid
      user.email = 'test@example.com'
      expect(user).to be_valid
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
          expect(user).to be_new_record
          expect(user).not_to be_persisted
          expect(user).not_to be_password_required
          # Invalid provider
          user.authentications.first.provider = nil
          expect(user).not_to be_password_required
          # Invalid + valid provider
          user.authentications << FactoryGirl.build(:authentication)
          expect(user).not_to be_password_required
          # Not updating password
          user.password = user.password_confirmation = nil
          expect(user).not_to be_password_required
          # Updating password
          user.password = user.password_confirmation = 'abcabcabc'
          expect(user).not_to be_password_required
        end
      end
      context "and persisted" do
        let(:user) {
          user = stub_model User, persisted?: true
          user.authentications << authentication
          user
        }
        it "is persisted" do
          expect(user).to be_persisted
        end
        it "is false when has at least one valid authentication" do
          user.encrypted_password = nil
          authentication.provider = nil
          user.authentications << [authentication, FactoryGirl.build(:authentication)]
          expect(user).not_to be_password_required
        end
        it "is false when has saved password" do
          user.encrypted_password = '123123'
          expect(user).not_to be_password_required
          user.authentications.first.provider = nil
          expect(user).not_to be_password_required
        end
        it "is true when no saved password and invalid authentication" do
          user.encrypted_password = ''
          expect(user).not_to be_password_required
          user.authentications.first.provider = nil
          expect(user).to be_password_required
        end
        it "is true when password is present" do
          expect(user).not_to be_password_required
          user.password = 'abcabc'
          expect(user).to be_password_required
          user.password = nil
          user.password_confirmation = 'abcabc'
          expect(user).to be_password_required
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
          expect(user).to be_new_record
          expect(user).not_to be_persisted
          expect(user).to be_password_required
          user.password = user.password_confirmation = nil
          expect(user).to be_password_required
          user.password = user.password_confirmation = ''
          expect(user).to be_password_required
          user.password = '123123123'
          user.password_confirmation = nil
          expect(user).to be_password_required
          user.password = nil
          user.password_confirmation = 'abcabcabc'
          expect(user).to be_password_required
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
          expect(user).to be_password_required
          user.password = nil
          user.password_confirmation = '123'
          expect(user).to be_password_required
        end
        it "is true when saved password is not present" do
          user.encrypted_password = ''
          expect(user).to be_password_required
        end
        it "is false when password is not present" do
          expect(user).not_to be_password_required
        end
      end
    end
  end

  describe "#authentications" do
    it "has many dependent authentications" do
      expect(user).to have_many(:authentications).dependent(:destroy)
    end
    describe "#grouped_with_oauth" do
      it "groups by provider and includes oauth_cache" do
        user.save
        FactoryGirl.create(:authentication, user: user, provider: 'facebook')
        FactoryGirl.create(:authentication, user: user, provider: 'twitter')
        FactoryGirl.create(:authentication, user: user, provider: 'linkedin')
        FactoryGirl.create(:authentication, user: user, provider: 'facebook')
        FactoryGirl.create(:authentication, user: user, provider: 'twitter')
        auths = user.authentications.grouped_with_oauth
        expect(auths.keys.length).to eq(3)
        expect(auths['facebook'].length).to eq(2)
        expect(auths['twitter'].length).to eq(2)
        expect(auths['linkedin'].length).to eq(1)
      end
    end
  end

  describe "#reverse_merge_attributes_from_auth" do
    it "merges email" do
      user.email = nil
      email = 'auth@domain.com'
      authentication.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(authentication)
      expect(user.email).to eq(email)
    end
    it "does not merge email" do
      email = 'somerandom@email.com'
      authentication.oauth_data = {email: email}
      user.reverse_merge_attributes_from_auth(authentication)
      expect(user.email).not_to eq(email)
    end
  end

  describe "case insensitive email lookup" do
    it "finds email" do
      user.email = 'ABC-abc@TestExample.com'
      user.save
      expect(User.find_by_email('abc-ABC@tEstEXample.COM')).to eq(user)
    end
  end
end

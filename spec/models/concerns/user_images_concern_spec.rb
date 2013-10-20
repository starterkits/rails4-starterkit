require 'spec_helper'

describe Concerns::UserImagesConcern do
  let(:user) { FactoryGirl.build(:user) }

  describe "#gravatar_url" do
    it "is nil if email is blank" do
      user.email = nil
      user.gravatar_url.should be_blank
    end

    it "returns correct url" do
      require 'digest/md5'
      email = 'Test@Example.COM'
      user.email = email
      md5_email = Digest::MD5.hexdigest(email.strip.downcase)
      user.gravatar_url.should ==  "https://secure.gravatar.com/avatar/#{md5_email}"
    end

    it "updates when email changes" do
      email = 'text@example.com'
      old_gravatar = user.gravatar_url
      user.email.should_not == email
      user.email = email
      user.gravatar_url.should_not == old_gravatar
    end
  end
end

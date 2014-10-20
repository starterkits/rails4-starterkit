require 'spec_helper'

describe Concerns::UserImagesConcern, :type => :model do
  let(:user) { FactoryGirl.build(:user) }

  describe "#image_url" do
    it "returns image_url if present" do
      url = 'http://example.com/image.png'
      user.image_url = url
      expect(user.image_url).to eq(url)
    end
    it "returns gravatar when image_url is not set" do
      user.image_url = nil
      expect(user.image_url).to match(/gravatar\.com/)
    end
    skip it "should check facebook, linkedin, twitter sizes"
  end

  describe "#gravatar_url" do
    it "is nil if email is blank" do
      user.email = nil
      expect(user.gravatar_url).to be_blank
    end
    it "returns correct url" do
      require 'digest/md5'
      email = 'Test@Example.COM'
      user.email = email
      md5_email = Digest::MD5.hexdigest(email.strip.downcase)
      expect(user.gravatar_url(size: :thumb, ssl: true)).to eq("https://secure.gravatar.com/avatar/#{md5_email}?s=#{user.image_sizes[:thumb]}")
      expect(user.gravatar_url(size: :thumb, ssl: false)).to eq("http://gravatar.com/avatar/#{md5_email}?s=#{user.image_sizes[:thumb]}")
    end
    it "updates when email changes" do
      email = 'text@example.com'
      old_gravatar = user.gravatar_url
      expect(user.email).not_to eq(email)
      user.email = email
      expect(user.gravatar_url).not_to eq(old_gravatar)
    end
    it "returns correct size" do
      user.image_sizes.each do |size, value|
        expect(user.gravatar_url(size: size)).to match(/s=#{value}$/)
      end
    end
    it "returns thumb if size is invalid" do
      expect(user.gravatar_url(size: :invalid_size)).to match(/s=#{user.image_sizes[:thumb]}$/)
    end
  end
end

require 'spec_helper'

describe Concerns::UserImagesConcern do
  let(:user) { FactoryGirl.build(:user) }

  describe "#image_url" do
    it "returns image_url if present" do
      url = 'http://example.com/image.png'
      user.image_url = url
      user.image_url.should == url
    end
    it "returns gravatar when image_url is not set" do
      user.image_url = nil
      user.image_url.should =~ /gravatar\.com/
    end
    skip it "should check facebook, linkedin, twitter sizes"
  end

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
      user.gravatar_url(size: :thumb, ssl: true).should ==  "https://secure.gravatar.com/avatar/#{md5_email}?s=#{user.image_sizes[:thumb]}"
      user.gravatar_url(size: :thumb, ssl: false).should ==  "http://gravatar.com/avatar/#{md5_email}?s=#{user.image_sizes[:thumb]}"
    end
    it "updates when email changes" do
      email = 'text@example.com'
      old_gravatar = user.gravatar_url
      user.email.should_not == email
      user.email = email
      user.gravatar_url.should_not == old_gravatar
    end
    it "returns correct size" do
      user.image_sizes.each do |size, value|
        user.gravatar_url(size: size).should =~ /s=#{value}$/
      end
    end
    it "returns thumb if size is invalid" do
      user.gravatar_url(size: :invalid_size).should =~ /s=#{user.image_sizes[:thumb]}$/
    end
  end
end

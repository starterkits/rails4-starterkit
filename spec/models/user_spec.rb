require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:authentication) { FactoryGirl.build(:authentication) }

  describe "#create" do
    it "should require password" do
      user.password = nil
      user.should_not be_valid
      user.password = 'testpass'
      user.should be_valid
    end
    it "should require email" do
      user.email = nil
      user.should_not be_valid
      user.email = 'test@connect.me'
      user.should be_valid
    end
  end

  describe "#destroy" do
    it "should remove authentications" do
      user.save
      authentication.user = user
      authentication.save
      Authentication.where(user_id: user.id).count.should == 1
      user.destroy
      Authentication.where(user_id: user.id).count.should == 0
    end
  end
end

class UserPreview < ActionMailer::Preview
  def welcome_email
    user = User.new FactoryGirl.attributes_for(:user)
    UserMailer.welcome_email(user)
  end
end

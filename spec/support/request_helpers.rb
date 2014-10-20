# http://schneems.com/post/15948562424/speed-up-capybara-tests-with-devise
#
# Usage:
#
# scenario 'works while logged in' do
#   as_user(user).visit teach_path
# end
#
# scenario 'creating a class' do
#   as_user(user) do
#      visit teach_path
#      click_link('Create')
#      current_path.should == new_course_path
#      fill_in 'course_title',       :with => course_stub.title
#      click_button 'Submit'
#   end
# end

module RequestHelpers
  include Devise::TestHelpers
  include Warden::Test::Helpers

  def create_logged_in_user
    as_user
  end

  def login_as(user, opts = {})
    Warden.on_next_request do |proxy|
      proxy.session_serializer.store(user, Devise::Mapping.find_scope!(user))
    end
  end

  def as_user(user=nil, &block)
    current_user = user || FactoryGirl.create(:user)
    if defined? request and request.present?
      sign_in(current_user)
    else
      login_as(current_user, :scope => :user)
    end
    block.call if block.present?
    current_user
  end

  def as_admin(user=nil, &block)
    user ||= FactoryGirl.create(:user, is_admin: true)
    user.update(is_admin: true) unless user.is_admin?
    as_user(user, &block)
  end

  def as_visitor(user=nil, &block)
    current_user = user || allow(FactoryGirl).to(receive(:user))
    if defined? request and request.present?
      sign_out(current_user)
    else
      logout(:user)
    end
    block.call if block.present?
    current_user
  end
end

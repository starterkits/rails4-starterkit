require 'spec_helper'

describe Users::RegistrationsController do
  describe "#create" do
    it "should redirect to after sign up url" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: {first_name: 'Test', email: 'test@example.com', password: 'testpass'}
      path = controller.send(:after_sign_up_path_for, controller.resource)
      URI(response.redirect_url).path.should == path
    end
  end
end


# 
# describe RegistrationsController do
#   before do
#     request.env["devise.mapping"] = Devise.mappings[:user]
#   end
# 
#   it 'should not require tos' do
#     get :new
#     response.should be_success
#   end
# 
#   describe "GET new" do
#     context "from a facebook login" do
#       before do
#         session[:omniauth] = {
#           "provider"=>"facebook",
#           "uid"=>"7911119",
#           "credentials"=>
#            {"token"=>
#              "155395127882013|f69bea41a9715896e96b01c1-7911119|3B072Y-DWZHKeDihwC46bu-zeMo"},
#           "user_info"=>
#            {"nickname"=>"john.smith",
#             "first_name"=>"John",
#             "last_name"=>"Simth",
#             "name"=>"John Smith",
#             "urls"=>
#              {"Facebook"=>"http://www.facebook.com/john.smith", "Website"=>nil}},
#           "extra"=>
#            {"user_hash"=>
#              {"id"=>"7911119",
#               "name"=>"John Smith",
#               "first_name"=>"John",
#               "last_name"=>"Woosley",
#               "link"=>"http://www.facebook.com/john.smith",
#               "gender"=>"male",
#               "email"=>"john.smith@gmail.com",
#               "timezone"=>-8,
#               "locale"=>"en_US",
#               "verified"=>true,
#               "updated_time"=>"2011-01-06T01:21:05+0000"}}
#         }
# 
#         @user = Factory.create(:user)
#       end
# 
#       it "should succeed" do
#         get :new
#         response.should be_success
#       end
#     end
#   end
# 
#   describe :create do
#     before(:each) do
#       session[:omniauth] = {
#         "provider"=>"facebook",
#         "uid"=>"7911119",
#         "credentials"=>
#          {"token"=>
#            "155395127882013|f69bea41a9715896e96b01c1-7911119|3B072Y-DWZHKeDihwC46bu-zeMo"},
#         "user_info"=>
#          {"nickname"=>"john.smith",
#           "first_name"=>"John",
#           "last_name"=>"Simth",
#           "name"=>"John Smith",
#           "urls"=>
#            {"Facebook"=>"http://www.facebook.com/john.smith", "Website"=>nil}},
#         "extra"=>
#          {"user_hash"=>
#            {"id"=>"7911119",
#             "name"=>"John Smith",
#             "first_name"=>"John",
#             "last_name"=>"Woosley",
#             "link"=>"http://www.facebook.com/john.smith",
#             "gender"=>"male",
#             "email"=>"john.smith@gmail.com",
#             "timezone"=>-8,
#             "locale"=>"en_US",
#             "verified"=>true,
#             "updated_time"=>"2011-01-06T01:21:05+0000"}}
#       }
#     end
#     it "should create a conversion event on the notification" do
#       @from       = Factory.create(:user_with_authentication)
#       @to_profile = Factory(:profile,{
#         uid: session[:omniauth]['uid'],
#         provider_type: session[:omniauth]['provider'],
#       })
#       @connection ||= Factory(:profile_connection,{
#         from: @from.profiles.first,
#         to:   @to_profile,
#       })
#       @notification = Notification::Vouch.create!({
#         user: @from,
#         profile_connection_id: @connection.id.to_param,
#         message: "test message",
#       })
#       session[:code] = @notification
#       post :create
#       response.should redirect_to(user_root_path)
#       @notification.reload.signup_events.count.should == 1
#       event = @notification.reload.signup_events.first
#       event.session_id.should_not be_blank
#       event.user.should_not be_blank
#     end
#   end
# end

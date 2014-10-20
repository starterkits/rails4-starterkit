require 'spec_helper'

describe Users::OauthController, :type => :controller do
  describe "#set_vars" do
    def test_path(path, test = 'should')
      controller.send(:set_vars)
      controller.instance_variable_get('@origin').send(test) == path
    end

    it "sets @origin from omniauth.origin" do
      path = '/some_path'
      request.env['omniauth.origin'] = path
      test_path(path)
    end

    it "sets @origin from params if no omniauth.origin" do
      path = '/some_path'
      controller.params['origin'] = path
      test_path(path)
    end

    it "sets @origin to default path when origin is home, login, or sign up page" do
      test_path(request.env['omniauth.origin'] = new_user_registration_path, 'should_not')
      test_path(request.env['omniauth.origin'] = new_user_session_path, 'should_not')
      test_path(request.env['omniauth.origin'] = root_path, 'should_not')
      test_path(request.env['omniauth.origin'] = nil, 'should_not')
    end
  end
end

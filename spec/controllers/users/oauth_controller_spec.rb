require 'rails_helper'

describe Users::OauthController, :type => :controller do
  describe "#set_vars" do
    def test_path(path, test = 'to')
      controller.send(:set_vars)
      expect(controller.instance_variable_get '@origin').send test, eq(path)
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
      test_path(request.env['omniauth.origin'] = new_user_registration_path, 'not_to')
      test_path(request.env['omniauth.origin'] = new_user_session_path, 'not_to')
      test_path(request.env['omniauth.origin'] = root_path, 'not_to')
      test_path(request.env['omniauth.origin'] = nil, 'not_to')
    end
  end
end

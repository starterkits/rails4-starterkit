require 'spec_helper'

# Capybara docs: http://rubydoc.info/github/jnicklas/capybara/master

describe "rails_admin" do
  context "as visitor" do
    it "redirects to login page" do
      visit rails_admin.dashboard_path
      current_path.should == new_user_session_path
      page.should have_content(I18n.t 'devise.failure.unauthenticated')
    end
  end
  context "as user" do
    it "redirects to user home page" do
      as_user do
        visit rails_admin.dashboard_path
        current_path.should == user_home_path
        page.should have_content(I18n.t 'unauthorized.default')
      end
    end
  end
  context "as admin" do
    it "displays admin dashbaord" do
      as_admin do
        visit rails_admin.dashboard_path
        current_path.should == rails_admin.dashboard_path
        page.should have_content('Site Administration')
      end
    end
  end
end

describe "sidekiq" do
  context "as visitor" do
    it "redirects to login page" do
      visit sidekiq_path
      current_path.should == new_user_session_path
      page.should have_content(I18n.t 'devise.failure.unauthenticated')
    end
  end
  context "as user" do
    it "redirects to user home page" do
      as_user do
        visit sidekiq_path
        current_path.should == user_home_path
        page.should have_content(I18n.t 'unauthorized.default')
      end
    end
  end
  context "as admin" do
    it "displays admin dashbaord" do
      as_admin do
        visit sidekiq_path
        current_path.should == sidekiq_path
        page.should have_content('Sidekiq')
      end
    end
  end
end
